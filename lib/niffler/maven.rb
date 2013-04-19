require 'open-uri'
require 'json'

class Niffler
  class Maven
    attr_accessor :group, :artifact, :version, :repository, :packaging
    BASE_URL = "http://search.maven.org/solrsearch/select?"
    EXT_URL = "&wt=json&rows=500"
    
    def initialize(opts)
      @group = opts.fetch(:group)
      @artifact = opts.fetch(:artifact)
      @version = opts.fetch(:version)
      @repository = opts.fetch(:repository)
      @packaging = opts.fetch(:packaging)
    end
    
    def self.group_query(group)
      # build the query for groups
      url = BASE_URL+"q=#{group}"+EXT_URL
      # open is the open-uri, which returns a io-string object, so we need to convert that to a encoded string
      response = open(url)
      
      # open-uri will save the response as a temp file if it's too large, so check what the class is before parsing
      if response.kind_of?(StringIO)
        resp_string = response.string
      else
        resp_string = response.read
      end
      
      json = JSON.parse(resp_string)
      
      # json will look like the following
      # {"responseHeader"=>{"status"=>0, "QTime"=>1, "params"=>{"spellcheck"=>"true", "fl"=>"id,g,a,latestVersion,p,ec,repositoryId,text,timestamp,versionCount", "sort"=>"score desc,timestamp desc,g asc,a asc", "indent"=>"off", "q"=>"guice", "qf"=>"text^20 g^5 a^10", "spellcheck.count"=>"5", "wt"=>"json", "rows"=>"20", "version"=>"2.2", "defType"=>"dismax"}}, "response"=>{"numFound"=>234, "start"=>0, "docs"=>[{"id"=>"com.jolira:guice", "g"=>"com.jolira", "a"=>"guice", "latestVersion"=>"3.0.0", "repositoryId"=>"central", "p"=>"jar", "timestamp"=>1301724755000, "versionCount"=>8, "text"=>["com.jolira", "guice", "-javadoc.jar", "-sources.jar", ".jar", ".pom"], "ec"=>["-javadoc.jar", "-sources.jar", ".jar", ".pom"]}
      results = []
      # response docs refers to the portion of the response with the software metadata for each result
      for r in json["response"]["docs"]
        result = Niffler::Maven.new(group: r["g"], artifact: r["a"], version: r["latestVersion"], 
          repository: r["repositoryId"], packaging: r["p"])
        results << result
      end # for result
      
      return results
    end # def find_by_group
  end # class Maven
end # class Niffler