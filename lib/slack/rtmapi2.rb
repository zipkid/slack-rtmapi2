require 'slack/rtmapi2/client'
require 'slack/rtmapi2/version'
require 'slack_web'

require 'net/http'

# Slack
class Slack
  # class Slack Real Time Messaging API
  class RtmApi2
    attr_writer :client
    attr_accessor :rtm_state_data
    def self.get_url(options)
      body = SlackWeb.call(method: 'rtm.start', token: options[:token])
      URI(body['url'])
    end

    def initialize(options)
      @token = options.fetch(:token)
      @api_url = options[:slack_api_url] || 'https://slack.com/api'
    end

    def start_rtm
      @rtm_state_data = SlackWeb.call(method: 'rtm.start', token: @token)
      @websocket_url = URI(@rtm_state_data['url'])
      client
    end

    def client
      @client ||= Slack::RtmApi2::Client.new websocket_url: @websocket_url
    end
  end
end
