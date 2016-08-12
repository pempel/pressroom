module Pressroom
  class CreateChangelog
    include Service

    def initialize(sha:, tag: "")
      @sha = sha.to_s
      @tag = tag.to_s
    end

    def call
      tag_from = GetLatestGithubReleaseTag.call
      if tag.empty?
        tag_to = ShortenGithubSha.call(sha: sha)
        CreateGithubTag.call(tag: tag_to, sha: sha)
        changelog = GenerateChangelog.call(tag_from: tag_from, tag_to: tag_to)
        DeleteGithubTag.call(tag: tag_to)
      else
        tag_to = tag
        unless CheckIfGithubTagExists.call(tag: tag_to)
          CreateGithubTag.call(tag: tag_to, sha: sha)
        end
        changelog = GenerateChangelog.call(tag_from: tag_from, tag_to: tag_to)
      end
      changelog
    end

    private

    attr_reader :sha, :tag
  end
end
