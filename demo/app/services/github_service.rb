module Services
  class GithubService
    include HTTParty
    base_uri 'https://api.github.com:443'
    format :json

    def initialize
      @options = {headers: {'User-Agent' => 'service_layer demo'}}
    end

    def source
      "GitHub"
    end

    def gists(username)
      self.class.get("/users/#{username}/gists", @options)
    end

    def number_of_snippets(username)
      gists(username).size
    end
  end
end
