module ClusterText
  module Tfidf
    
    require 'tf_idf'

    def self.calculate(text_array)
      tfidf_data = TfIdf.new(text_array)
      tfidf_data.tf_idf
    end

  end
end
