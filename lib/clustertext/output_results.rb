module ClusterText
  module OutputResults

    def self.write(output_path, output_filename, cluster_groups, desk_case_link)
      ClusterText.log("outputting results")

      debug_bar_path = output_path + "html/debug_bar.html"
      debug_bar_html = File.read(debug_bar_path)
      
      output_file = output_path + output_filename

      File.open(output_file, 'w') do |f|  
        f << "<html>\n"
        f << "<head>\n"
        f << "<script type='text/javascript' src='scripts/jqcollapse/jquery.js'></script>\n"
        f << "<script type='text/javascript' src='scripts/jqcollapse/jquery.easing.js'></script>\n"
        f << "<script type='text/javascript' src='scripts/jqcollapse/jquery.collapse.js'></script>\n"
        f << "<script type='text/javascript' src='scripts/base.js'></script>\n"
        f << "<link rel='stylesheet' type='text/css' href='styles/base.css'/>\n"
        f << "</head>\n"
        f << "<body>\n"
        f << debug_bar_html
        f << "<ul id='collapser'>\n"


        sorted_cluster_groups = cluster_groups.sort_by {|obj| obj.cluster_items.length}
        sorted_cluster_groups.reverse!

        sorted_cluster_groups.each do |cluster_group|
          ClusterText.log("Group:   #{cluster_group.group_id}") 
          ClusterText.log("Keywords:    #{cluster_group.top_keywords.join(' ')}") 
          ClusterText.log("Num of items:    #{cluster_group.cluster_items.length}") 

          f << "  <li class='group-header'>\n"
          f << "    <span class='group-top-keywords'>Group: #{cluster_group.top_keywords.join(' ')}</span>\n"
          ClusterText.log("cluster top keywords size is #{cluster_group.top_keywords.size}")
          ClusterText.log("and cluster keywords size is #{cluster_group.keywords.size}")
          f << "    <span class='debug group-keywords'>#{cluster_group.keywords[cluster_group.top_keywords.size + 1 .. cluster_group.keywords.size].join(' ')}</span>\n"
          f << "    <span class='group-id'>Group Id: #{cluster_group.group_id}</span>\n"
          f << "    <span class='group-item-count'>(#{cluster_group.cluster_items.length})</span>\n"
          f << "      <ul>\n"
          
          cluster_group.cluster_items.each do |cluster_item|
            f << "         <li class='item'>\n"
            f << "           <p class='debug item-id'><b>Desk Id:</b> #{cluster_item.item_id}</p>\n"
            f << "           <p class='debug item-tfidf'><b>TF-IDF:</b> #{cluster_item.tfidf.nil? ? "not calculated" : cluster_item.tfidf}</p>\n"
            f << "           <p class='debug item-text'><b>Analysed text:</b> #{cluster_item.text}</p>\n"
            f << "           <blockquote>"
            f << "             <p class='item-original-text'><a target='_blank' href='#{desk_case_link}#{cluster_item.item_id}'>#{cluster_item.original_text}</a></p>\n"
            f << "           </blockquote>"
            f << "         </li>\n"
          end

          f << "      </ul>\n"
          f << "  </li>\n"

        end
        f << "</ul>\n"
        f << "</html>"
      end

      ClusterText.log("Output written to #{output_file}")
    end
  end
end
