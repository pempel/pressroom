module Pressroom
  class CreateGithubTag
    include Service

    def initialize(tag:, sha:)
      @tag = tag.to_s
      @sha = sha.to_s
    end

    def call
      github = Pressroom.configuration.github_api_client
      github.git_data.references.create(ref: "refs/tags/#{tag}", sha: sha)
      true
    end

    private

    attr_reader :tag, :sha
  end
end
