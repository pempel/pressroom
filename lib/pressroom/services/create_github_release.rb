module Pressroom
  class CreateGithubRelease
    include Service

    def initialize(tag:, sha:, changelog:)
      @tag = tag.to_s
      @sha = sha.to_s
      @changelog = changelog
    end

    def call
      user = Pressroom.configuration.github_user
      github = Pressroom.configuration.github_api_client
      github.repos.releases.create(
        owner: user,
        tag_name: tag,
        target_commitish: sha,
        name: tag,
        body: changelog.to_markdown,
        draft: false,
        prerelease: false
      )
      true
    rescue Github::Error::GithubError => error
      if error.status == 422
        false
      else
        raise error
      end
    end

    private

    attr_reader :tag, :sha, :changelog
  end
end
