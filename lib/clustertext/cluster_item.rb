module ClusterText
  class ClusterItem

    attr_accessor :item_id, :text, :original_text, :tfidf, :cluster_group

    def initialize(item_id, text)
      @item_id = item_id
      @original_text = text
      @text = text
      @tfidf = nil
      @cluster_group = nil
    end

  end
end
