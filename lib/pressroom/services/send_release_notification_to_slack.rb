require "rest-client"

module Pressroom
  class SendReleaseNotificationToSlack
    include Service

    def initialize(env:, ref:, ref_url:, changelog:)
      @env = env.to_s
      @ref = ref.to_s
      @ref_url = ref_url.to_s
      @changelog = changelog
    end

    def call
      url = Pressroom.configuration.slack_incoming_webhook_url
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

    def headers
      @_headers ||= {content_type: "application/json"}
    end

    def params
      @_params ||= {
        icon_emoji: Pressroom.configuration.slack_icon_emoji,
        username: Pressroom.configuration.slack_user_name,
        channel: Pressroom.configuration.slack_channel_name,
        attachments: attachments
      }
    end

    def attachments
      @_attachments ||= begin
        attachments = [{
          color: "good",
          title: Pressroom.configuration.app_title(env),
          title_link: Pressroom.configuration.app_url(env),
          text: message
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

    def message
      @_message ||= begin
        app_doc_url = Pressroom.configuration.app_doc_url(env)
        message = "<#{ref_url}|Исходный код: #{ref}>"
        message += "\n<#{app_doc_url}|Документация>" unless app_doc_url.empty?
        message
      end
    end
  end
end
