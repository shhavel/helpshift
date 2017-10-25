require "spec_helper"

RSpec.describe Helpshift::Api do
  before do
    Helpshift.configure do |config|
      config.customer_domain = 'oreillys-sbox'
      config.api_key = 'oreillys-sbox_api_1234-abcd'
    end
  end

  it "fetches issues" do
    stub_request(:get, "https://api.helpshift.com/v1/oreillys-sbox/issues?page-size=2").
      with(headers: {'Authorization'=>'Basic b3JlaWxseXMtc2JveF9hcGlfMTIzNC1hYmNk'}).
      to_return(status: 200, body: '{"page":1,"page-size":2,"issues":[{"tags":[],"assignee_name":null,"app_id":"oreillys-sbox_app_1234-abcd","title":"Hello World","messages":[{"body":"Hello World","created_at":1508878886891,"author":{"name":"Tom Dev","id":"oreillys-sbox_profile_20171023151716362-1f72413e382ddcc","emails":["tommy@example.com"]},"origin":"end-user"}],"assignee_id":"unassigned","id":179,"author_name":"Tom Dev","author_email":"tommy@example.com","domain":"oreillys-sbox","state_data":{"state":"new","changed_at":1508878886891},"created_at":1508878886891},{"tags":[],"assignee_name":"Tommy","app_id":"oreillys-sbox_app_1234-abcd","title":"Hello","messages":[{"body":"Hello","created_at":1508790614370,"author":{"name":"Tom Dev","id":"oreillys-sbox_profile_20171023203014263-e945cbeb76f4f2c","emails":["tommy@example.com"]},"origin":"end-user"},{"body":"yo","created_at":1508790644613,"author":{"name":"Tommy","id":"oreillys-sbox_profile_20170808190153929-8171e38ce11b6e9","emails":["thomas.devoy@example.com"]},"origin":"helpshift"},{"body":"Yo","created_at":1508790660302,"author":{"name":"Tom Dev","id":"oreillys-sbox_profile_20171023203014263-e945cbeb76f4f2c","emails":["tommy@example.com"]},"origin":"end-user"},{"body":"AsdasdadsfF","created_at":1508790982269,"author":{"name":"Tom Dev","id":"oreillys-sbox_profile_20171023203014263-e945cbeb76f4f2c","emails":["tommy@example.com"]},"origin":"end-user"},{"body":"ASDFADSFASDF","created_at":1508790997129,"author":{"name":"Tommy","id":"oreillys-sbox_profile_20170808190153929-8171e38ce11b6e9","emails":["thomas.devoy@example.com"]},"origin":"helpshift"},{"body":"asdasf","created_at":1508791022013,"author":{"name":"Tommy","id":"oreillys-sbox_profile_20170808190153929-8171e38ce11b6e9","emails":["thomas.devoy@example.com"]},"origin":"helpshift"},{"body":"Accepted the solution","created_at":1508791027925,"author":{"name":"Tom Dev","id":"oreillys-sbox_profile_20171023203014263-e945cbeb76f4f2c","emails":["tommy@example.com"]},"origin":"end-user"}],"assignee_id":"oreillys-sbox_profile_20170808190153929-8171e38ce11b6e9","id":178,"author_name":"Tom Dev","author_email":"tommy@example.com","domain":"oreillys-sbox","state_data":{"state":"resolved","changed_at":1508791027925},"created_at":1508790614370}],"total-hits":179,"total-pages":90}')

    response = described_class.new.get('/issues', :'page-size' => 2)
    expect(response.code).to eql(200)
    expect(response['issues']).to be_an(Array)
    expect(response['issues'].count).to eql(2)
  end
end



