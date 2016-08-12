module Pressroom
  class Release
    def initialize(env:, sha:, tag:, changelog:)
      @env = env.to_s
      @sha = sha.to_s
      @tag = tag.to_s
      @changelog = changelog
    end

    def self.create(env:, sha:, tag: "")
      changelog = Changelog.create(sha: sha, tag: tag)
      unless tag.to_s.empty?
        CreateGithubRelease.call(sha: sha, tag: tag, changelog: changelog)
      end
      Release.new(env: env, sha: sha, tag: tag, changelog: changelog)
    end

    def send_notification_to_slack
      if tag.empty?
        ref = ShortenGithubSha.call(sha: sha)
        ref_url = BuildGithubReferenceUrl.call(ref: sha)
      else
        ref = tag
        ref_url = BuildGithubReferenceUrl.call(ref: tag)
      end
      SendReleaseNotificationToSlack.call(
        env: env,
        ref: ref,
        ref_url: ref_url,
        changelog: changelog
      )
    end

    private

    attr_reader :env, :sha, :tag, :changelog
  end
end
