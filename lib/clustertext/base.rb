#encoding: UTF-8

module ClusterText

  DESK_CASE_LINK = "YOUR_URL_HERE"
  CLUSTER_KEYWORD_MAX_SIZE = 10

  # ToDo:
  # Sub-clustering
  # Rename cluster.description to cluster.keywords and split with commas
  # When displaying group description, make first two bold, then show another few in brackets
  # Find top word freqs across all text. Then manual process to remove popular, unrelated terms (add as stop words).
  # Correct common spelling mistakes (ur -> your), and see if you can get spell corrector to work (same length words, matched words match)
  # Experiment with tf-idf more
  # Format HTML
  # Start tweaking!

  def self.process(args) 
    log("starting")
    
    @input_path              = args[:input_path]
    @output_path             = args[:output_path]
    @output_filename         = args[:output_filename]
    @debug                   = args[:debug]
    @correct_spelling        = args[:correct_spelling]
    @remove_email_signatures = args[:remove_email_signatures]
    @remove_stopwords        = args[:remove_stopwords]
    @singularise_words       = args[:singularise_words]
    @calculate_tfidf         = args[:calculate_tfidf]
    @kmeans_cluster          = args[:kmeans_cluster]
    @cluster_size            = args[:cluster_size]
    @cluster_group_keyword_count  = args[:cluster_group_keyword_count]

    process_cluster
  end

  def self.log(message)
    puts "[DEBUG]: #{message}" if @debug
  end

  class << self

    def process_cluster
      @cluster_items = create_cluster_array(@input_path)
      @cluster_groups = create_cluster_group_array(@cluster_size)

      # optional steps
      correct_spelling        if @correct_spelling
      remove_email_signatures if @remove_email_signatures
      calculate_tfidf         if @calculate_tfidf
      remove_stopwords        if @remove_stopwords
      singularise_words       if @singularise_words
      kmeans_cluster          if @kmeans_cluster

      # debug
      frequency_analysis

      # required steps
      cluster_analysis
      OutputResults.write(@output_path, @output_filename, @cluster_groups, DESK_CASE_LINK)
    end

    private

    def remove_email_signatures
      log("Removing email signatures")
      @cluster_items.each do |cluster_item|
        cluster_item.text = EmailSignatures.remove(cluster_item.text) 
      end
    end

    def correct_spelling
      log("Correcting spelling")

      @cluster_items.each do |cluster_item|
        cluster_item.text = Spell.correct(cluster_item.text)         
      end
    end

    def calculate_tfidf
      log("Calculating tf-idf")

      cluster_text_array = [] 
      @cluster_items.each do |cluster_item|
        cluster_text_array.push(cluster_item.text.split) 
      end
  
      tfidf_data = Tfidf.calculate(cluster_text_array)

      array_counter = 0
      tfidf_data.each do |data|
        tfidf_sorted_data = data.sort_by { |word,freq| -freq}
        @cluster_items[array_counter].tfidf = tfidf_sorted_data
        array_counter += 1
      end
    end

    def remove_stopwords
      log("Removing stopwords")

      @cluster_items.each do |cluster_item|
        cluster_item.text = StopWords.remove(cluster_item.text)         
      end
    end

    def singularise_words
      log("Singularising words")

      @cluster_items.each do |cluster_item|
        cluster_item.text = SingulariseWords.singularise(cluster_item.text)         
      end
    end

    def kmeans_cluster
      log("Performing K-Means with #{@cluster_size} cluster(s)")

      # get an array of just the cluster text
      cluster_text_items = @cluster_items.map(&:text)
      # perform kmeans clustering
      kmeans_clusters = KMeans.cluster(cluster_text_items, @cluster_size)

      # iterate over each group, matching the kmean items .object value against
      # the cluster items text value, so each cluster item can be assigned it's cluster group number
      cluster_group_id = 0
      kmeans_clusters.each do |cluster|
        current_cluster_group = @cluster_groups[cluster_group_id]
        cluster.documents.each do |document|
          index = @cluster_items.find_index {|item| item.text == document.object}
          @cluster_items[index].cluster_group = current_cluster_group
          current_cluster_group.cluster_items.push(@cluster_items[index])
        end
        cluster_group_id += 1
      end
    end

    def cluster_analysis
      @cluster_groups.each do |cluster_group|
        cluster_group.keywords = ClusterAnalysis.analyse(cluster_group.all_words.split(/[^a-zA-Z]/), CLUSTER_KEYWORD_MAX_SIZE)
        cluster_group.top_keywords = cluster_group.keywords[1..@cluster_group_keyword_count]
        log("Cluster top keywords are: #{cluster_group.top_keywords.join(' ')}")
      end
    end

    def create_cluster_array(path)
      cluster_array = []
      
      total_file_count = Dir[File.join(path, '**', '*')].count { |file| File.file?(file) }

      log("Total file count = #{total_file_count}")

      Dir.entries(path).each do |file|
        next if file == '.' 
        next if file == '..' 

        # read file in
        file_contents = File.read(path + "/" + file)
        
        cluster_array.push(ClusterItem.new(file, file_contents))
      end

      cluster_array
    end

    def create_cluster_group_array(size)
      cluster_group_array = []
      for i in 1..size
        cluster_group_array.push(ClusterGroup.new(i)) 
      end

      cluster_group_array
    end

    # todo: delete
    require 'tf_idf'
    def frequency_analysis
      all_words = ""
      @cluster_groups.each do |cluster_group|
        all_words << cluster_group.all_words
      end
      
      #log("all words is #{all_words}")
      all_words_array = [all_words.split()]
      a = TfIdf.new(all_words_array)
      #log("all word freq is #{a.tf}")

      c =a.tf
      d = c[0].sort_by { |word,freq| -freq}
      #log("analysed results=#{d}")
      
      d.each do |result|
        #log("\nresult: #{result}")
      end
    end

  end
end
