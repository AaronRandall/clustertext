module ClusterText
  module KMeans

    require 'clusterer'
    include Clusterer

    def self.cluster(text_array, num_of_clusters)
      document_array = []
      text_array.each do |text|
        document = Document.new(text)
        document_array.push(document)
      end

      kmeans_results = Algorithms.kmeans(document_array, num_of_clusters)

      puts kmeans_results

      kmeans_results
    end

  end
end
