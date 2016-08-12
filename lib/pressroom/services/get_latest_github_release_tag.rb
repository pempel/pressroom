module Pressroom
  class GetLatestGithubReleaseTag
    include Service

    def call
      user = Pressroom.configuration.github_user
      github = Pressroom.configuration.github_api_client
      github.repos.releases.latest(owner: user).body.tag_name
    rescue Github::Error::NotFound
      ""
    end
  end
end
