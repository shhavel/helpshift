require 'helpshift/version'
require 'helpshift/configuration'
require 'helpshift/api'

module Helpshift
  def self.config
    @config ||= Configuration.new
  end

  def self.configure
    yield(config)
  end
end
