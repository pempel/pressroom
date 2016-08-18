module Pressroom
  class CheckIfGithubTagExists
    include Service

    def initialize(tag:)
      @tag = tag.to_s
    end

    def call
      github = Pressroom.configuration[:github_api_client]
      github.git_data.references.get(ref: "tags/#{tag}")
      true
    rescue Github::Error::NotFound
      false
    end

    private

    attr_reader :tag
  end
end
