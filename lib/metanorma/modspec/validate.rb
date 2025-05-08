require "tsort"

module Metanorma
  class Requirements
    class Modspec < Default
      def validate(reqt, log)
        @log ||= log
        @ids ||= reqt_links(reqt.document)
        reqt_cycles_validate
        reqt_link_validate(reqt)
      end

      def nested_reqt?(reqt)
        reqt.at("./ancestor::requirement | ./ancestor::recommendation | " \
                "./ancestor::permission")
      end

      def reqt_link_validate(reqt)
        return if nested_reqt?(reqt)

        reqt_to_conformance(reqt, "general", "verification")
        reqt_to_conformance(reqt, "class", "conformanceclass")
        conformance_to_reqt(reqt, "general", "verification")
        conformance_to_reqt(reqt, "class", "conformanceclass")
        class_to_children(reqt, "class", "general")
        class_to_children(reqt, "conformanceclass", "verification")
        children_to_class(reqt, "verification", "conformanceclass")
        reqt_to_dependency(reqt)
      end

      def type2validate(reqt)
        type = reqt["type"]
        type = "general" if type.nil? || type.empty?
        type = "verification" if type == "abstracttest"
        type
      end

      CLASS2LABEL = {
        general: "Requirement",
        verification: "Conformance test",
        class: "Requirement class",
        conformanceclass: "Conformance class",
        provision: "Provision",
        dependency: "Prerequisite",
        indirect_dependency: "Indirect prerequisite",
        implements: "Implemented provision",
      }.freeze

      def log_reqt(reqt, leftclass, rightclass)
        @log.add("Requirements", reqt[:elem], <<~MSG
          #{CLASS2LABEL[leftclass.to_sym]} #{reqt[:label] || reqt[:id]} has no corresponding #{CLASS2LABEL[rightclass.to_sym]}
        MSG
        )
      end

      def log_reqt2(reqt, leftclass, target, rightclass)
        @log.add("Requirements", reqt[:elem], <<~MSG
          #{CLASS2LABEL[leftclass]} #{reqt[:label] || reqt[:id]} points to #{CLASS2LABEL[rightclass]} #{target} outside this document
        MSG
        )
      end

      def reqt_to_dependency(reqt)
        r = @ids[:id][reqt["id"]]
        %i(dependency indirect_dependency implements).each do |x|
          r[x].each do |d|
            @ids[:label][d] or log_reqt2(r, :provision, d, x)
          end
        end
      end

      def reqt_to_conformance(reqt, reqtclass, confclass)
        return unless type2validate(reqt) == reqtclass
        r = @ids[:id][reqt["id"]]
        (r[:label] && @ids[:class][confclass]&.any? do |x|
           x[:subject].include?(r[:label])
         end) and return
        log_reqt(r, reqtclass, confclass)
      end

      def conformance_to_reqt(reqt, reqtclass, confclass)
        return unless type2validate(reqt) == confclass

        r = @ids[:id][reqt["id"]]
        (r[:subject] && @ids[:class][reqtclass]&.any? do |x|
           r[:subject].include?(x[:label])
         end) and return
        log_reqt(r, confclass, reqtclass)
      end

      def class_to_children(reqt, type, childclass)
        return unless type2validate(reqt) == type

        r = @ids[:id][reqt["id"]]
        !r[:child].empty? and return
        log_reqt(r, type, childclass)
      end

      def children_to_class(reqt, childclass, parentclass)
        return unless type2validate(reqt) == childclass

        r = @ids[:id][reqt["id"]]
        (r[:label] && @ids[:class][parentclass]&.any? do |x|
           x[:child].include?(r[:label])
         end) and return
        log_reqt(r, childclass, parentclass)
      end

      def reqt_links(docxml)
        docxml.xpath("//requirement | //recommendation | //permission")
          .each_with_object({ id: {}, class: {}, label: {} }) do |r, m|
            next if nested_reqt?(r)

            reqt_links1(r, m, type2validate(r), reqt_links_struct(r))
          end
      end

      def reqt_links1(reqt, hash, type, struct)
        hash[:id][reqt["id"]] = struct
        hash[:class][type] ||= []
        hash[:class][type] << struct
        reqt_links1_label(reqt, hash, struct)
      end

      def reqt_links1_label(reqt, hash, struct)
        return hash unless struct[:label]

        if hash[:label][struct[:label]]
          msg = "Modspec identifier #{struct[:label]} is used more than once"
          @log.add("Requirements", reqt, msg, severity: 0)
        end
        hash[:label][struct[:label]] = reqt["id"]
        hash
      end

      def classif_tag(reqt, tag)
        reqt.xpath("./classification[tag][value]")
          .each_with_object([]) do |c, m|
          c.at("./tag").text.casecmp(tag).zero? or next
          m << c.at("./value").text
        end
      end

      def reqt_links_struct(reqt)
        { id: reqt["anchor"], elem: reqt, label: reqt.at("./identifier")&.text,
          subject: classif_tag(reqt, "target"),
          child: reqt.xpath("./requirement | ./recommendation | ./permission")
            .map { |r| r.at("./identifier")&.text },
          dependency: reqt.xpath("./inherit").map(&:text),
          indirect_dependency: classif_tag(reqt, "indirect-dependency"),
          implements: classif_tag(reqt, "implements") }
      end

      def reqt_cycles_validate
        @cycles_validated and return
        @cycles_validated = true
        %i(child dependency indirect_dependency implements).each do |x|
          reqt_cycles_validate1(x)
        end
      end

      def reqt_cycles_validate1(link)
        arr = TSHash.new(@ids[:id].values)
        arr.link = link
        TSort.each_strongly_connected_component(
          lambda { |&b| arr.tsort_each_node(&b) },
          lambda { |n, &b| arr.tsort_each_child(n, &b) },
        ) do |c|
          c.size == 1 and next
          log_cycle(link, c)
        end
      end

      def log_cycle(link, path)
        @log.add("Requirements", nil, <<~MSG
          Cycle in Modspec linkages through #{link}: #{(path << path.first).join(' => ')}
        MSG
        )
      end

      class TSHash
        include TSort
        attr_accessor :link

        def initialize(arr)
          @hash = arr.each_with_object({}) do |v, m|
            m[v[:label]] = v
          end
        end

        def tsort_each_node(&block)
          @hash.keys.each(&block)
        end

        def tsort_each_child(node, &block)
          (@hash[node] || {})[@link]&.each(&block)
        end
      end

      def reqt_cycles_validate_dependency; end
    end
  end
end
