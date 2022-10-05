module Metanorma
  class Requirements
    class Modspec < Default
      def validate(reqt, log)
        @log ||= log
        @ids ||= reqt_links(reqt.document)
        reqt_link_validate(reqt)
      end

      def nested_reqt?(reqt)
        reqt.at("./ancestor::requirement | ./ancestor::recommendation | "\
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
      }.freeze

      def log_reqt(reqt, leftclass, rightclass)
        @log.add("Requirements", reqt[:elem],
                 "#{CLASS2LABEL[leftclass.to_sym]} #{reqt[:label] || reqt[:id]} "\
                 "has no corresponding #{CLASS2LABEL[rightclass.to_sym]}")
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
          .each_with_object({ id: {}, class: {} }) do |r, m|
            next if nested_reqt?(r)

            reqt_links1(r, m)
          end
      end

      def reqt_links1(reqt, hash)
        type = type2validate(reqt)
        hash[:id][reqt["id"]] = reqt_links_struct(reqt)
        hash[:class][type] ||= []
        hash[:class][type] << hash[:id][reqt["id"]]
        hash
      end

      def reqt_links_struct(reqt)
        { id: reqt["id"], elem: reqt, label: reqt.at("./identifier")&.text,
          subject: reqt.xpath("./classification[tag = 'target']/value")
            .map(&:text),
          child: reqt.xpath("./requirement | ./recommendation | ./permission")
            .map do |r|
                   r.at("./identifier")&.text
                 end }
      end
    end
  end
end
