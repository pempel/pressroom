require "rest-client"

module Pressroom
  class SendReleaseNotificationToSlack
    include Service

    def initialize(env:, ref:, ref_url:, changelog:)
      @env = env.to_s.downcase.to_sym
      @ref = ref.to_s
      @ref_url = ref_url.to_s
      @changelog = changelog
    end

    def call
      url = config[:slack_incoming_webhook_url]
      response = RestClient.post(url, params.to_json, headers)
      true
    rescue RestClient::Exception => error
      puts "Error: #{error.http_code} #{error.http_body}"
      false
    rescue SocketError => error
      puts "Error: #{error.message}"
      false
    end

    private

    attr_reader :env, :ref, :ref_url, :changelog

    def config
      @_config ||= Pressroom.configuration
    end

    def headers
      @_headers ||= {content_type: "application/json"}
    end

    def params
      @_params ||= {
        icon_emoji: config[:slack_icon_emoji],
        username: config[:slack_user_name],
        channel: config[:slack_channel_name],
        attachments: attachments
      }
    end

    def attachments
      @_attachments ||= begin
        title = config[env][:title]
        links = config[env][:links]
        attachments = [{
          color: "good",
          title: "#{title} - #{ref}",
          text: ["<#{ref_url}|исходный код>"].concat(links).join(" / ")
        }]
        if changelog.empty?
          attachments.push({
            color: "good",
            text: changelog.empty_text,
            mrkdwn_in: ["text"]
          })
        else
          changelog.groups.each do |group|
            text = "*#{group.title}*\n"
            group.changes.each do |change|
              text += "- <#{change.issue_url}|##{change.issue_number}>"
              text += " #{change.text}\n"
            end
            attachments.push({
              color: "good",
              text: text,
              mrkdwn_in: ["text"]
            })
          end
        end
        attachments
      end
    end
  end
end
