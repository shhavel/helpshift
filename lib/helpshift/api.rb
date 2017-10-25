require 'httparty'
require 'base64'

module Helpshift
  class Api
    include ::HTTParty
    format :json

    def initialize
      config = ::Helpshift.config
      raise ::Helpshift::Configuration::Error.new('Not configured') unless config.customer_domain && config.api_key
      self.class.base_uri "#{config.base_domain}#{config.customer_domain}"
      @headers = { 'Authorization' => "Basic #{::Base64.encode64(config.api_key).gsub("\n", '')}" }
    end

    def get(url, query = {})
      self.class.get(url, query: query, headers: @headers)
    end
  end
end
