require "uri"

module Metanorma
  class Requirements
    class Modspec < Default
      def requirement_table_cleanup(node, table)
        table = requirement_table_nested_cleanup(node, table)
        requirement_table_consec_rows_cleanup(node, table)
        node.ancestors("requirement, recommendation, permission").empty? and
          truncate_id_base_in_reqt(table)
        cell2link(table)
        table
      end

      def cell2link(table)
        table.xpath(ns(".//td")).each do |td|
          td.elements.empty? or next
          uri?(td.text.strip) or next
          td.children = "<link target='#{td.text.strip}'/>"
        end
      end

      def uri?(string)
        uri = URI.parse(string)
        %w(http https).include?(uri.scheme)
      rescue URI::BadURIError, URI::InvalidURIError
        false
      end

      def requirement_table_consec_rows_cleanup(_node, table)
        table.xpath(ns("./tbody/tr")).each do |tr|
          conflate_table_rows?(tr) or next
          conflate_table_rows(tr)
        end
      end

      def conflate_table_rows?(trow)
        tr1 = trow.next or return
        tr1.name == "tr" or return
        th = trow.at(ns("./th"))&.text
        th && th == tr1.at(ns("./th"))&.text
      end

      def conflate_table_rows(trow)
        th = trow.at(ns("./th"))
        hdr = th.text
        th.children = @i18n.inflect(hdr, number: "pl")
        td = th.next_element
        res = [td.children.to_xml]
        res += gather_consec_table_rows(trow, hdr)
        td.children = res.join("<br/>")
      end

      def gather_consec_table_rows(trow, hdr)
        ret = []
        trow.xpath("./following-sibling::xmlns:tr").each do |r|
          r.at(ns("./th[text() = '#{hdr}']")) or break
          ret << r.remove.at(ns("./td")).children.to_xml
        end
        ret
      end

      def requirement_table_nested_cleanup(node, table)
        table.xpath(ns("./tbody/tr/td/table")).each do |t|
          x = t.at(ns("./thead/tr")) or next
          x.at(ns("./th")).children =
            requirement_table_nested_cleanup_hdr(node)
          f = x.at(ns("./td/fmt-name")) and
            f.replace(f.children)
          t.parent.parent.replace(x)
        end
        table
      end

      def requirement_table_nested_cleanup_hdr(node)
        label = "provision"
        node["type"] == "conformanceclass" and label = "conformancetest"
        @i18n.get["requirements"]["modspec"][label]
      end

      def strip_id_base(elem, base)
        base.nil? and return elem.children
        elem.children.to_xml.delete_prefix(base)
      end

      def truncate_id_base_in_reqt1(table, base)
        table.xpath(ns(".//xref[@style = 'id']")).each do |x|
          @reqt_id_base[x["target"]] or next # is a modspec requirement
          x.children = strip_id_base(x, base)
        end
        table.xpath(ns(".//modspec-ident")).each do |x|
          x.replace(strip_id_base(x, base))
        end
      end

      # any xrefs not yet expanded out to rendering need to be expanded out,
      # so that the identifier instances they contain can be truncated
      def expand_xrefs_in_reqt(table)
        table.xpath(ns(".//xref[not(@style)][string-length() = 0]"))
          .each do |x|
          ref = @xrefs.anchor(x["target"], :xref, false) or next
          x << ref
        end
      end

      def truncate_id_base_in_reqt(table)
        base = @reqt_id_base[table["id"]]
        expand_xrefs_in_reqt(table)
        truncate_id_base_in_reqt1(table, base)
      end
    end
  end
end
