module Pressroom
  class ShortenGithubSha
    include Service

    def initialize(sha:)
      @sha = sha.to_s
    end

    def call
      %x[git rev-parse --short #{sha}].chomp
    end

    private

    attr_reader :sha
  end
end
