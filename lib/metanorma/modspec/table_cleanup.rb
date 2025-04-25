require "uri"

module Metanorma
  class Requirements
    class Modspec < Default
      def requirement_table_cleanup(node, out)
        table = out.at(ns("./fmt-provision/table"))
        table = requirement_table_nested_cleanup(node, out, table)
        requirement_table_consec_rows_cleanup(node, table)
        node.ancestors("requirement, recommendation, permission").empty? and
          truncate_id_base_in_reqt(table)
        cell2link(table)
        table["class"] = "modspec" # deferred; node["class"] is labelling class
        out.xpath(ns("./fmt-name | ./fmt-identifier")).each(&:remove)
        out
      end

      def cell2link(table)
        table.xpath(ns(".//td")).each do |td|
          td.elements.empty? ||
            (td.elements.size == 1 && td.elements.first.name == "semx") or next
          uri?(td.text.strip) or next
          td.children = "<link target='#{td.text.strip}'>#{to_xml(td.children)}</link>"
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
        hdr = plural_table_row_hdr(th)
        td = th.next_element
        id = td["id"] ? "<bookmark id='#{td['id']}'/>" : ""
        td.delete("id")
        res = [id + to_xml(td.children).strip]
        res += gather_consec_table_rows(trow, hdr)
        td.children = res.join("<br/>")
      end

      def plural_table_row_hdr(thdr)
        th1 = thdr.at(ns("./semx")) || thdr
        hdr = th1.text
        th1.children = @i18n.inflect(hdr, number: "pl")
        hdr
      end

      def gather_consec_table_rows(trow, hdr)
        ret = []
        trow.xpath("./following-sibling::xmlns:tr").each do |r|
          r.at(ns("./th"))&.text&.strip == hdr or break
          td = r.remove.at(ns("./td"))
          id = td["id"] ? "<bookmark id='#{td['id']}'/>" : ""
          ret << id + to_xml(td.children).strip
        end
        ret
      end

      def requirement_table_nested_cleanup(node, out, table)
        rows = []
        table.xpath(ns("./tbody/tr/td/*/fmt-provision/table"))
          .sort_by do |t|
            [t.at(ns(".//fmt-name//span[@class = 'fmt-element-name']"))&.text,
             t.at(ns(".//fmt-name//semx[@element = 'autonum']"))&.text&.to_i]
          end.each do |t|
            x = t.at(ns("./thead/tr")) or next
            x.at(ns("./th")).children =
              requirement_table_nested_cleanup_hdr(node)
            f = x.at(ns("./td/fmt-name")) and
              f.parent.children = to_xml(f.children).strip
            td = x.at(ns("./td"))
            td["id"] = t["original-id"] || t["id"]
            if desc = t.at(ns("./tbody/tr/td/semx[@element = 'description']"))
              p = desc.at(ns("./p")) and p.replace(p.children)
              td << " #{to_xml(desc)}"
            end
            rows << x
          end
        table.xpath(ns("./tbody/tr[./td/*/fmt-provision/table]"))
          .each_with_index do |t, i|
          t.replace(rows[i])
        end
        out.xpath(ns("./*/fmt-provision")).each(&:remove)
        table
      end

      def requirement_table_nested_cleanup_hdr(node)
        label = "provision"
        node["type"] == "conformanceclass" and label = "conformancetest"
        @i18n.get["requirements"]["modspec"][label]
      end

      def strip_id_base(elem, base)
        base.nil? and return elem.children
        to_xml(elem.children).delete_prefix(base)
      end

      def truncate_id_base_in_reqt1(table, base)
        table.xpath(ns(".//xref[@style = 'id']")).each do |x|
          @reqt_id_base[x["target"]] or next # is a modspec requirement
          n = x.at(ns("./semx")) and x = n
          x.children = strip_id_base(x, base)
        end
        table.xpath(ns(".//modspec-ident")).each do |x|
          n = x.at(ns("./semx")) || x
          n.children = strip_id_base(n, base)
          n != x and x.replace(n)
        end
      end

      # any xrefs not yet expanded out to rendering need to be expanded out,
      # so that the identifier instances they contain can be truncated
      def expand_xrefs_in_reqt(table)
        table.xpath(ns(".//xref[not(@style)][string-length() = 0]"))
          .each do |x|
            @xrefs.anchor(x["target"], :modspec, false) or next # modspec xrefs only
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
