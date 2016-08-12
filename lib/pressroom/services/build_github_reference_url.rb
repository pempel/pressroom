module Pressroom
  class BuildGithubReferenceUrl
    include Service

    def initialize(ref:)
      @ref = ref.to_s
    end

    def call
      user = Pressroom.configuration.github_user
      repo = Pressroom.configuration.github_repo
      "https://github.com/#{user}/#{repo}/tree/#{ref}"
    end

    private

    attr_reader :ref
  end
end
