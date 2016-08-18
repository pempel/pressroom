module Pressroom
  class Configuration
    PARAMS = %w[
      SLACK_USER_NAME
      SLACK_ICON_EMOJI
      SLACK_CHANNEL_NAME
      SLACK_INCOMING_WEBHOOK_URL
      GITHUB_REPOSITORY_NAME
      GITHUB_USER_NAME
      GITHUB_TOKEN
      TITLE
      LINKS
    ]

    def initialize
      @options = {}
      @options[:default] = {}
      ENV.each_pair do |name, value|
        PARAMS.each do |param|
          match = name.match(/^PRESSROOM_(.*)_#{param}$/)
          unless match.nil?
            env = match.captures.first.to_s.downcase.to_sym
            param = param.downcase.to_sym
            value = UnescapeString.call(value)
            value = value.scan(/(<[^>]+>)/).map(&:first) if param == :links
            @options[env] ||= {}
            @options[env][param] = value
          end
        end
      end
      @options[:github_api_client] = Github.new do |config|
        config.user = @options[:github_user_name]
        config.repo = @options[:github_repository_name]
        config.oauth_token = @options[:github_token]
      end
    end

    def [](param)
      @options[param] || @options[:default][param]
    end
  end

  def self.configuration
    @_configuration ||= Configuration.new
  end
end
