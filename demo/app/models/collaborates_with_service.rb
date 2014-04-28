class CollaboratesWithService
  extend ServiceLayer::Dependent
  services :github_service
  
  def test_connection
    !!github_service.gists('lwoodson')
  end
end
