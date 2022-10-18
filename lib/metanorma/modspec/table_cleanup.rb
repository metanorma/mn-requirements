module Metanorma
  class Requirements
    class Modspec < Default
      def requirement_table_cleanup(node, table)
        table = requirement_table_nested_cleanup(node, table)
        requirement_table_consec_rows_cleanup(node, table)
        table
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
          break unless r.at(ns("./th[text() = '#{hdr}']"))

          ret << r.remove.at(ns("./td")).children.to_xml
        end
        ret
      end

      def requirement_table_nested_cleanup(node, table)
        table.xpath(ns("./tbody/tr/td/table")).each do |t|
          x = t.at(ns("./thead/tr")) or next
          x.at(ns("./th")).children =
            requirement_table_nested_cleanup_hdr(node)
          t.parent.parent.replace(x)
        end
        table
      end

      def requirement_table_nested_cleanup_hdr(node)
        label = "provision"
        node["type"] == "conformanceclass" and label = "conformancetest"
        @i18n.get["requirements"]["modspec"][label]
      end
    end
  end
end
