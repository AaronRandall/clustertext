module ClusterText
  class ClusterGroup

    attr_accessor :group_id, :top_keywords, :keywords, :cluster_items, :all_words

    def initialize(group_id = nil, top_keywords = nil, keywords = nil, cluster_items = nil)
      @group_id = group_id
      @top_keywords = top_keywords
      @keywords = keywords
      @cluster_items = cluster_items || []
    end

    def all_words
      @all_words ||= get_all_cluster_words
    end

    private 

    def get_all_cluster_words
      cluster_words = ""
      @cluster_items.each do |cluster_item|
        cluster_words << cluster_item.text 
      end

      cluster_words
    end 

  end
end
