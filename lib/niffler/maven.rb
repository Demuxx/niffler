require 'open-uri'
require 'cgi'
require 'json'

class Niffler
  class Maven
    attr_accessor :group, :artifact, :version, :repository, :packaging
    BASE_URL = "http://search.maven.org/solrsearch/select?"
    JSON_URL = "&wt=json"
    ROWS_URL = "&rows=500"
    ROW_URL  = "&rows=1"
    
    def initialize(opts)
      @group = opts.fetch(:group)
      @artifact = opts.fetch(:artifact)
      @version = opts.fetch(:version)
      @repository = opts.fetch(:repository)
      @packaging = opts.fetch(:packaging)
    end
    
    def self.groups_query(name)
      # build the query for groups specifying 500 maximum responses
      url = BASE_URL+"q="+CGI::escape(name)+JSON_URL+ROWS_URL
      json = fetch_json(url)
      results = parse_json(json)
      return results
    end # def find_by_group
    
    def self.group_query(name)
      # build the query for a group specifying only one response
      url = BASE_URL+"q="+CGI::escape(name)+JSON_URL+ROWS_URL
      # returns an array with a single entry
      json = fetch_json(url)
      result = parse_json(json).last
      return result
    end # def self.group_query
    
    def self.artifacts_query(name)
      # build the query for an artifact specifying 500 maximum responses
      url = BASE_URL+"q="+CGI::escape("a:\"#{name}\"")+JSON_URL+ROWS_URL
      json = fetch_json(url)
      results = parse_json(json)
      return results
    end # def self.artifacts_query
    
    def self.artifact_query(name)
      # build the query for artifacts specifying only one response
      url = BASE_URL+"q="+CGI::escape("a:\"#{name}\"")+JSON_URL+ROW_URL
      json = fetch_json(url)
      result = parse_json(json).last
      return result
    end # def self.artifact_query
    
    def self.hash_query(hash)
      url = BASE_URL+"q="+CGI::escape("1:\"#{hash}\"")+JSON_URL+ROW_URL
      json = fetch_json(url)
      result = parse_hash_json(json)
      return result
    end # def self.hash_query
    
    private
    def self.fetch_json(url)
      # open is the open-uri, which returns a io-string object, so we need to convert that to a encoded string
      response = open(url)
      
      # open-uri will save the response as a temp file if it's too large, so check what the class is before parsing
      if response.kind_of?(StringIO)
        resp_string = response.string
      else
        resp_string = response.read
      end
      
      json = JSON.parse(resp_string)
      return json
    end # def self.fetch_json
    
    def self.parse_json(json)
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
    end # def query
    
    def self.parse_hash_json(json)
      # json will look like the following
      # {"responseHeader"=>{"status"=>0, "QTime"=>1, "params"=>{"spellcheck"=>"true", "fl"=>"id,g,a,latestVersion,p,ec,repositoryId,text,timestamp,versionCount", "sort"=>"score desc,timestamp desc,g asc,a asc", "indent"=>"off", "q"=>"guice", "qf"=>"text^20 g^5 a^10", "spellcheck.count"=>"5", "wt"=>"json", "rows"=>"20", "version"=>"2.2", "defType"=>"dismax"}}, "response"=>{"numFound"=>234, "start"=>0, "docs"=>[{"id"=>"com.jolira:guice", "g"=>"com.jolira", "a"=>"guice", "latestVersion"=>"3.0.0", "repositoryId"=>"central", "p"=>"jar", "timestamp"=>1301724755000, "versionCount"=>8, "text"=>["com.jolira", "guice", "-javadoc.jar", "-sources.jar", ".jar", ".pom"], "ec"=>["-javadoc.jar", "-sources.jar", ".jar", ".pom"]}
      # response docs refers to the portion of the response with the software metadata for each result
      r = json["response"]["docs"].last
      result = Niffler::Maven.new(group: r["g"], artifact: r["a"], version: r["v"], 
        repository: r["repositoryId"], packaging: r["p"])
      return result
    end # def parse_response
  end # class Maven
end # class Niffler