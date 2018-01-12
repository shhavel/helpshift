require 'helpshift/version'
require 'httparty'

module Helpshift
  include HTTParty

  BASE_DOMAIN = 'https://api.helpshift.com/v1/'.freeze
  CONFIGURATION = Struct.new(:customer_domain, :api_key)
  ConfigurationError = Class.new(StandardError)

  def self.config
    @config ||= CONFIGURATION.new
  end

  def self.configure
    yield(config)
  end

  def self.base_uri
    @base_uri ||= if config.customer_domain
      "#{BASE_DOMAIN}#{config.customer_domain}"
    else
      raise ConfigurationError, 'customer_domain is required'
    end
  end

  def self.headers
    @headers ||= if config.api_key
      require 'base64'
      { 'Accept' => 'application/json', 'Authorization' => "Basic #{::Base64.encode64(config.api_key).gsub("\n", '')}" }
    else
      raise ConfigurationError, 'api_key is required'
    end
  end

  def self.get(path, query = {})
    perform_request Net::HTTP::Get, path, base_uri: base_uri, query: query, headers: headers, format: :json
  end

  def self.put(path, body)
    perform_request Net::HTTP::Put, path, base_uri: base_uri, headers: headers, body: body, format: :json
  end

  def self.post(path, body)
    perform_request Net::HTTP::Post, path, base_uri: base_uri, headers: headers, body: body, format: :json
  end
end
