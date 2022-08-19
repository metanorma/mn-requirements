module Metanorma
  class Requirements
    class Modspec < Default
      def recommendation_label(elem, type, xrefs)
        label = elem.at(ns("./identifier"))&.text
        if inject_crossreference_reqt?(elem, label)
          number = xrefs.anchor(reqtlabels(elem.document, label), :xref, false)
          number.nil? ? type : number
        else
          type = recommendation_class_label(elem)
          super
        end
      end

      def reqtlabels(doc, label)
        @reqtlabels ||= doc
          .xpath(ns("//requirement | //recommendation | //permission"))
          .each_with_object({}) do |r, m|
            l = reqt.at(ns("./label"))&.text and
              m[l] = r["id"]
          end
        @reqtlabels[label]
      end

      # embedded reqts xref to top level reqts via label lookup
      def inject_crossreference_reqt?(node, label)
        !node.ancestors("requirement, recommendation, permission").empty? &&
          reqtlabels[label]
      end

      def recommendation_class_label(node)
        case node["type"]
        when "verification" then @labels["#{node.name}test"]
        when "class" then @labels["#{node.name}class"]
        when "abstracttest" then @labels["abstracttest"]
        when "conformanceclass" then @labels["conformanceclass"]
        else
          case node.name
          when "recommendation" then @labels["recommendation"]
          when "requirement" then @labels["requirement"]
          when "permission" then @labels["permission"]
          end
        end
      end

      def reqt_ids(docxml)
        docxml.xpath(ns("//requirement | //recommendation | //permission"))
          .each_with_object({}) do |r, m|
            id = r.at(ns("./identifier")) or next
            m[id.text] = r["id"]
          end
      end

      def reqt_links(docxml)
        docxml.xpath(ns("//requirement | //recommendation | //permission"))
          .each_with_object({}) do |r, m|
            next unless %w(conformanceclass
                           verification).include?(r["type"])

            subj = r.at(ns("./classification[tag = 'target']/value"))
            id = r.at(ns("./identifier"))
            next unless subj && id

            m[subj.text] = { lbl: id.text, id: r["id"] }
          end
      end

      def recommendation_link(docxml, ident)
        @reqt_links ||= reqtlinks(docxml)
        test = @reqt_links[ident&.strip] or return nil
        "<xref target='#{test[:id]}'>#{test[:lbl]}</xref>"
      end

      def recommendation_id(docxml, ident)
        @reqt_ids ||= reqt_ids(docxml)
        test = @reqt_ids[ident&.strip] or return ident&.strip
        "<xref target='#{test}'>#{ident.strip}</xref>"
      end
    end
  end
end
