module Pressroom
  class Configuration
    ENV_PARAMS = %w[APP_TITLE APP_URL APP_DOC_URL]

    attr_accessor :slack_incoming_webhook_url
    attr_accessor :slack_channel_name
    attr_accessor :slack_user_name
    attr_accessor :slack_icon_emoji

    attr_accessor :github_user
    attr_accessor :github_repo
    attr_accessor :github_token

    def initialize
      @slack_incoming_webhook_url = ENV["PRESSROOM_SLACK_INCOMING_WEBHOOK_URL"]
      @slack_channel_name = ENV["PRESSROOM_SLACK_CHANNEL_NAME"] || "#general"
      @slack_user_name = ENV["PRESSROOM_SLACK_USER_NAME"] || "pressroom"
      @slack_icon_emoji = ENV["PRESSROOM_SLACK_ICON_EMOJI"] || ":tada:"
      @github_user = ENV["PRESSROOM_GITHUB_USER"]
      @github_repo = ENV["PRESSROOM_GITHUB_REPO"]
      @github_token = ENV["PRESSROOM_GITHUB_TOKEN"]
      @environments = {}
      ENV.each_pair do |name, value|
        ENV_PARAMS.each do |param|
          match = name.match(/^PRESSROOM_ENV_(.*)_#{param}$/)
          unless match.nil?
            param_name = param.downcase.to_sym
            env_name = match.captures.first.downcase.to_sym
            @environments[env_name] ||= {}
            @environments[env_name][param_name] = UnescapeString.call(value)
          end
        end
      end
    end

    ENV_PARAMS.each do |param|
      param_name = param.downcase.to_sym
      define_method(param_name) do |env|
        env_name = env.to_s.downcase.to_sym
        @environments.fetch(env_name, {}).fetch(param_name, "")
      end
    end

    def github_api_client
      @github_api_client ||= begin
        Github.new do |config|
          config.user = github_user
          config.repo = github_repo
          config.oauth_token = github_token
        end
      end
    end
  end

  def self.configuration
    @configuration ||= Configuration.new
  end
end
