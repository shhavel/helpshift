module Helpshift
  class Configuration
    BASE_DOMAIN = 'https://api.helpshift.com/v1/'.freeze
    Error = Class.new(StandardError)

    attr_reader :base_domain
    attr_accessor :customer_domain, :api_key

    def initialize
      @base_domain = BASE_DOMAIN
    end
  end
end
