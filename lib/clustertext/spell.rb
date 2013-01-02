module ClusterText
  module Spell

    require 'spellingbee'

    def self.correct(text)
      spell_checker = SpellingBee.new :source_text => "#{ROOT}/../../files/holmes.txt"

      text_array = text.split

      corrected_text = []
      text_array.each do |word|
        corrected_text.push((spell_checker.correct word)[0])
      end

      corrected_text = corrected_text.join(' ')

      ClusterText.log("Corrected text from #{text} to #{corrected_text}")

      corrected_text
    end

  end
end
