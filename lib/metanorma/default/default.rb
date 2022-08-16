require "htmlentities"
require "metanorma-utils"
require_relative "cleanup"

module Metanorma
  class Requirements
    class Default
      def initialize
        @c = HTMLEntities.new
      end

      def noko(&block)
        Metanorma::Utils.noko(&block)
      end

      def attr_code(attributes)
        Metanorma::Utils.attr_code(attributes)
      end

      def csv_split(text, delim = ";")
        Metanorma::Utils.csv_split(text, delim)
      end

      def wrap_in_para(node, out)
        Metanorma::Utils.wrap_in_para(node, out)
      end

      def reqt_subpart?(name)
        %w[specification measurement-target verification import identifier title
           description component subject inherit classification].include? name
      end

      def reqt_subpart_attrs(node, name, attrs)
        klass = node.attr("class") || "component"
        attr_code(attrs
          .merge(exclude: node.option?("exclude"),
                 type: node.attr("type"),
                 class: name == "component" ? klass : nil))
      end

      def requirement_subpart(node, attrs)
        name = node.role || node.attr("style")
        noko do |xml|
          xml.send name, **reqt_subpart_attrs(node, name, attrs) do |o|
            o << node.content
          end
        end
      end

      def req_classif_parse(classif)
        ret = []
        @c.decode(classif).split(/;\s*/).each do |c|
          c1 = c.split(/:\s*/)
          next unless c1.size == 2

          c1[1].split(/,\s*/).each { |v| ret << [c1[0], v] }
        end
        ret
      end

      def requirement_classification(classif, out)
        req_classif_parse(classif).each do |r|
          out.classification do |c|
            c.tag { |t| t << r[0] }
            c.value { |v| v << r[1] }
          end
        end
      end

      def reqt_attrs(node, attrs)
        attr_code(attrs.merge(
                    id: Metanorma::Utils.anchor_or_uuid(node),
                    unnumbered: node.option?("unnumbered") ? "true" : nil,
                    number: node.attr("number"),
                    subsequence: node.attr("subsequence"),
                    obligation: node.attr("obligation"),
                    filename: node.attr("filename"),
                    type: node.attr("type"),
                  ))
      end

      def requirement_elems(node, out)
        node.title and out.title { |t| t << node.title }
        a = node.attr("identifier") and out.identifier do |l|
          l << out.text(a)
        end
        a = node.attr("subject") and csv_split(a)&.each do |subj|
          out.subject { |s| s << out.text(subj) }
        end
        a = @c.decode(node.attr("inherit")) and
          csv_split(a)&.each do |i|
            out.inherit do |inh|
              inh << @c.encode(i, :hexadecimal)
            end
          end
        classif = node.attr("classification") and
          requirement_classification(classif, out)
      end

      def requirement(node, obligation, attrs)
        noko do |xml|
          xml.send obligation, **reqt_attrs(node, attrs) do |ex|
            requirement_elems(node, ex)
            wrap_in_para(node, ex)
          end
        end.join("\n")
      end
    end
  end
end
