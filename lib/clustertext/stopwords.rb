module ClusterText
  module StopWords

  require 'stopwords'

    def self.remove(text)
      # remove some common (annoying) phrases from the text before removing stop words
      stop_phrases = ['http','www','|','&','>','://','--','/',':', '\"','(',')', "=)", 'awesome', 'brilliant','consider','wish','hello','hey', 'sorry', 'thanks', 'thank', 'sweet', 'guys', 'dudes', 'please', 'wonderful', 'fantastic', 'cool', 'amazing', 'nice', 'love', 'sent from my iPhone', 'sent from my iPad', 'sent from my iPod', 'sent from HTC Inspire', "sent from", "Songkick", "regards", "cheers"]

      # remove some common phrases before stop word removal
      stop_phrases.each do |stop_phrase|
        if text.downcase.include? stop_phrase.downcase
          text = text.downcase.gsub(stop_phrase.downcase, "")
        end
      end

      stop_words.each do |stop_word|
        text = text.downcase.gsub(/\b#{stop_word.downcase}\b/i, "")
      end

      # split text by whitespace and punctuation
      text_array = text.split(/[\s\.\,\?\!]/)
      # remove newlines
      text_array = text_array.join("\n").split

      text_array.map! {|item| item.downcase}

      # filter using the Snowball stopword filter
      filter = Stopwords::Snowball::Filter.new "en"
      stopword_free_text = filter.filter text_array 
      
      stopword_free_text.join(" ")
    end

    def self.stop_words
      #experimental_stop_words = ["information", "http","www","com","add", "app","a"]
      #experimental_stop_words = ["artist","'","concert","band","-","music","venue","location","event","list","track","calendar","feature","spotify","\"","gig","time","email","iphone","page","city","date"]
      experimental_stop_words = ["im","i'm","artist","'","concert","band","-","music","venue","location","event","list"]

      trusted_stop_words = ["i've", "i", "hi", "able","about","across","after","all","almost","also","am","among","an","and","any","are","as","at","be","because","been","but","by","can","cannot","could","dear","did","do","does","either","else","ever","every","for","from","get","got","had","has","have","he","her","hers","him","his","how","however","if","in","into","is","it","its","just","least","let","like","likely","may","me","might","most","must","my","neither","no","nor","not","of","off","often","on","only","or","other","our","own","rather","said","say","says","she","should","since","so","some","than","that","the","their","them","then","there","these","they","this","tis","to","too","twas","us","wants","was","we","were","what","when","where","which","while","who","whom","why","will","with","would","yet","you","your","a","about","above","across","after","again","against","all","almost","alone","along","already","also","although","always","among","an","and","another","any","anybody","anyone","anything","anywhere","are","area","areas","around","as","ask","asked","asking","asks","at","away","b","back","backed","backing","backs","be","became","because","become","becomes","been","before","began","behind","being","beings","best","better","between","big","both","but","by","c","came","can","cannot","case","cases","certain","certainly","clear","clearly","come","could","d","did","differ","different","differently","do","does","done","down","down","downed","downing","downs","during","e","each","early","either","end","ended","ending","ends","enough","even","evenly","ever","every","everybody","everyone","everything","everywhere","f","face","faces","fact","facts","far","felt","few","find","finds","first","for","four","from","full","fully","further","furthered","furthering","furthers","g","gave","general","generally","get","gets","give","given","gives","go","going","good","goods","got","great","greater","greatest","group","grouped","grouping","groups","h","had","has","have","having","he","her","here","herself","high","high","high","higher","highest","him","himself","his","how","however","if","important","in","interest","interested","interesting","interests","into","is","it","its","itself","j","just","k","keep","keeps","kind","knew","know","known","knows","l","large","largely","last","later","latest","least","less","let","lets","like","likely","long","longer","longest","m","made","make","making","man","many","may","me","member","members","men","might","more","most","mostly","mr","mrs","much","must","my","myself","n","necessary","need","needed","needing","needs","never","new","new","newer","newest","next","no","nobody","non","noone","not","nothing","now","nowhere","number","numbers","o","of","off","often","old","older","oldest","on","once","one","only","open","opened","opening","opens","or","order","ordered","ordering","orders","other","others","our","out","over","p","part","parted","parting","parts","per","perhaps","place","places","point","pointed","pointing","points","possible","present","presented","presenting","presents","problem","problems","put","puts","q","quite","r","rather","really","right","right","room","rooms","s","said","same","saw","say","says","second","seconds","see","seem","seemed","seeming","seems","sees","several","shall","she","should","show","showed","showing","shows","side","sides","since","small","smaller","smallest","so","some","somebody","someone","something","somewhere","state","states","still","still","such","sure","t","take","taken","than","that","the","their","them","then","there","therefore","these","they","thing","things","think","thinks","this","those","though","thought","thoughts","three","through","thus","to","today","together","too","took","toward","turn","turned","turning","turns","two","u","under","until","up","upon","us","use","used","uses","v","very","w","want","wanted","wanting","wants","was","way","ways","we","well","wells","went","were","what","when","where","whether","which","while","who","whole","whose","why","will","with","within","without","work","worked","working","works","would","x","y","year","years","yet","you","young","younger","youngest","your","yours","z"]
      experimental_stop_words.concat(trusted_stop_words)
      #trusted_stop_words
    end
  end
end
