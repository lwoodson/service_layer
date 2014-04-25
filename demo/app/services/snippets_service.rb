module Services
  class SnippetsService
    extend ServiceLayer::Dependent
    services :snippet_providers

    def sources
      snippet_providers.map{|provider| provider.source}
    end

    def provider(source)
      snippet_providers.detect{|provider| provider.source == source}
    end

    def count(user, source="*")
      if source == "*"
        providers = snippet_providers
      else
        providers = [provider(source)]
      end

      providers.inject(0) do |result, provider|
        username = user.provider_account_data[provider.source]
        result += provider.number_of_snippets(username)
      end
    end
  end
end
