require "spec_helper"

RSpec.describe Helpshift do
  it "has a version number" do
    expect(Helpshift::VERSION).not_to be nil
  end

  it "is configurable" do
    Helpshift.configure do |config|
      config.customer_domain = 'oreillys-sbox'
      config.api_key = 'oreillys-sbox_api_1234-abcd'
    end
    expect(Helpshift::BASE_DOMAIN).to eq('https://api.helpshift.com/v1/')
    expect(Helpshift.config.customer_domain).to eq('oreillys-sbox')
    expect(Helpshift.config.api_key).to eq('oreillys-sbox_api_1234-abcd')
  end

  describe 'REST API' do
    before do
      Helpshift.configure do |config|
        config.customer_domain = 'oreillys-sbox'
        config.api_key = 'oreillys-sbox_api_1234-abcd'
      end
    end

    it "fetches issues" do
      stub_request(:get, "https://api.helpshift.com/v1/oreillys-sbox/issues?page-size=2").
         with(headers: {'Accept'=>'application/json', 'Authorization'=>'Basic b3JlaWxseXMtc2JveF9hcGlfMTIzNC1hYmNk'}).
         to_return(status: 200, body: '{"page":1,"page-size":2,"issues":[{"tags":[],"assignee_name":null,"app_id":"oreillys-sbox_app_1234-abcd","title":"Hello World","messages":[{"body":"Hello World","created_at":1508878886891,"author":{"name":"Tom Dev","id":"oreillys-sbox_profile_20171023151716362-1f72413e382ddcc","emails":["tommy@example.com"]},"origin":"end-user"}],"assignee_id":"unassigned","id":179,"author_name":"Tom Dev","author_email":"tommy@example.com","domain":"oreillys-sbox","state_data":{"state":"new","changed_at":1508878886891},"created_at":1508878886891},{"tags":[],"assignee_name":"Tommy","app_id":"oreillys-sbox_app_1234-abcd","title":"Hello","messages":[{"body":"Hello","created_at":1508790614370,"author":{"name":"Tom Dev","id":"oreillys-sbox_profile_20171023203014263-e945cbeb76f4f2c","emails":["tommy@example.com"]},"origin":"end-user"},{"body":"yo","created_at":1508790644613,"author":{"name":"Tommy","id":"oreillys-sbox_profile_20170808190153929-8171e38ce11b6e9","emails":["thomas.devoy@example.com"]},"origin":"helpshift"},{"body":"Yo","created_at":1508790660302,"author":{"name":"Tom Dev","id":"oreillys-sbox_profile_20171023203014263-e945cbeb76f4f2c","emails":["tommy@example.com"]},"origin":"end-user"},{"body":"AsdasdadsfF","created_at":1508790982269,"author":{"name":"Tom Dev","id":"oreillys-sbox_profile_20171023203014263-e945cbeb76f4f2c","emails":["tommy@example.com"]},"origin":"end-user"},{"body":"ASDFADSFASDF","created_at":1508790997129,"author":{"name":"Tommy","id":"oreillys-sbox_profile_20170808190153929-8171e38ce11b6e9","emails":["thomas.devoy@example.com"]},"origin":"helpshift"},{"body":"asdasf","created_at":1508791022013,"author":{"name":"Tommy","id":"oreillys-sbox_profile_20170808190153929-8171e38ce11b6e9","emails":["thomas.devoy@example.com"]},"origin":"helpshift"},{"body":"Accepted the solution","created_at":1508791027925,"author":{"name":"Tom Dev","id":"oreillys-sbox_profile_20171023203014263-e945cbeb76f4f2c","emails":["tommy@example.com"]},"origin":"end-user"}],"assignee_id":"oreillys-sbox_profile_20170808190153929-8171e38ce11b6e9","id":178,"author_name":"Tom Dev","author_email":"tommy@example.com","domain":"oreillys-sbox","state_data":{"state":"resolved","changed_at":1508791027925},"created_at":1508790614370}],"total-hits":179,"total-pages":90}')

      resp = Helpshift.get('/issues', :'page-size' => 2)
      expect(resp.code).to eql(200)
      expect(resp['issues']).to be_an(Array)
      expect(resp['issues'].count).to eql(2)
    end

    it 'fetches single issue' do
      stub_request(:get, 'https://api.helpshift.com/v1/oreillys-sbox/issues/4').
         with(headers: {'Accept'=>'application/json', 'Authorization'=>'Basic b3JlaWxseXMtc2JveF9hcGlfMTIzNC1hYmNk'}).
         to_return(status: 200, body: '{"page":1,"page-size":100,"issues":[{"tags":[],"meta":{},"custom_fields":{},"assignee_name":"Kinsey Eaton","app_id":"oreillys-sbox_app_20170721061817259-7602e7e2ab72b8f","title":"hi. which shoes would go with a black cocktail dress?","messages":[{"body":"hi. which shoes would go with a black cocktail dress?","created_at":1500656417601,"author":{"name":"serena","id":"oreillys-sbox_profile_20170721165947836-752718ef4230602","emails":["serena@example.com"]},"origin":"end-user"}],"assignee_id":"oreillys-sbox_profile_20170719002316050-bcf64ee2ef7953a","id":4,"author_name":"serena","author_email":"serena@example.com","domain":"oreillys-sbox","state_data":{"state":"resolved","changed_at":1500657362636},"created_at":1500656417601}],"total-hits":1,"total-pages":1}')

      resp = Helpshift.get('/issues/4')
      expect(resp.code).to eql(200)
      expect(resp['issues']).to be_an(Array)
      expect(resp['issues'].count).to eql(1)
      expect(resp['issues'][0]['messages'][0]['body']).to eq('hi. which shoes would go with a black cocktail dress?')
    end

    it "updates issue's custom_fields" do
      stub_request(:put, "https://api.helpshift.com/v1/oreillys-sbox/issues/4").
        with(headers: {'Accept'=>'application/json', 'Authorization'=>'Basic b3JlaWxseXMtc2JveF9hcGlfMTIzNC1hYmNk'}).
        to_return(status: 200, body: '{"updated-data":{"custom_fields":{"my_number_field":{"type":"number","value":43}}}}')

      resp = Helpshift.put("/issues/4", custom_fields: { my_number_field: { type: 'number', value: 43 } }.to_json)
      expect(resp.code).to eql(200)
      expect(resp['updated-data']['custom_fields']).to eq({'my_number_field' => { 'type' => 'number', 'value' => 43 }})
    end

    it "creates an issue" do
      stub_request(:post, "https://api.helpshift.com/v1/oreillys-sbox/issues").
        with(headers: {'Accept'=>'application/json', 'Authorization'=>'Basic b3JlaWxseXMtc2JveF9hcGlfMTIzNC1hYmNk'},
             body: 'email=your.email%40yourdomain.com&message-body=This%20is%20the%20message%20body').
        to_return(status: 201, body: '{"created_at":1515749028185,"id":"281","title":"This is the message body","tags":[],"meta":{},"custom_fields":{}}')

      resp = Helpshift.post("/issues", 'email' => 'your.email@yourdomain.com', 'message-body' => 'This is the message body')
      expect(resp.code).to eql(201)
      expect(resp.body).to eq('{"created_at":1515749028185,"id":"281","title":"This is the message body","tags":[],"meta":{},"custom_fields":{}}')
    end
  end
end
