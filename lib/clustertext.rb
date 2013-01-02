module ClusterText
  ROOT = File.expand_path('..', __FILE__) + "/clustertext"
  Dir["#{ROOT}/*.rb"].each {|file| require file; ClusterText.log("requiring file #{file}") }
end
