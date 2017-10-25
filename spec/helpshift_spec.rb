require "spec_helper"

RSpec.describe Helpshift do
  it "has a version number" do
    expect(Helpshift::VERSION).not_to be nil
  end

  it "is configurable" do
    described_class.configure do |config|
      config.customer_domain = 'oreillys-sbox'
      config.api_key = 'oreillys-sbox_api_1234-abcd'
    end
    expect(described_class.config.base_domain).to eq('https://api.helpshift.com/v1/')
    expect(described_class.config.customer_domain).to eq('oreillys-sbox')
    expect(described_class.config.api_key).to eq('oreillys-sbox_api_1234-abcd')
  end
end
