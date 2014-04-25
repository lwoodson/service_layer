module Services
  class JSFiddleService
    include HTTParty
    base_uri 'http://jsfiddle.net/api'

    def source
      "JSFiddle"
    end

    def fiddles(username)
      response = self.class.get("/user/#{username}/demo/list.json")
      JSON.parse(response.body)
    end

    def number_of_snippets(username)
      fiddles(username).size
    end
  end
end
