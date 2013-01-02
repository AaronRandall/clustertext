module ClusterText
  module SingulariseWords

    require 'active_support/inflector'

    def self.singularise(text)
      text_array = text.split

      singularised_text_array = []
      text_array.each do |word|
        singular = ActiveSupport::Inflector.singularize(word)    
        singularised_text_array.push(singular)
      end
     
      singularised_text = singularised_text_array.join(" ")

      singularised_text
    end

  end
end
