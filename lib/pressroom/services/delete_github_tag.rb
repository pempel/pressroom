module Pressroom
  class DeleteGithubTag
    include Service

    def initialize(tag:)
      @tag = tag.to_s
    end

    def call
      github = Pressroom.configuration[:github_api_client]
      github.git_data.references.delete(ref: "tags/#{tag}")
      true
    end

    private

    attr_reader :tag
  end
end
