module ClusterText
  module ClusterAnalysis

    def self.analyse(words, max_size = nil)
      freqs = Hash.new(0)
      words.each { |word| freqs[word] += 1 }
      freqs = freqs.sort_by {|x,y| y }

      highest_freq_words = []

      max_size = freqs.size if max_size.nil?

      freqs.reverse![0..max_size].each { |x,y| highest_freq_words.push(x) }
      highest_freq_words
    end
  end
end
