require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe MxitMoneyApi do

  before :each do
    token_body = %&{
                    "balance": 5000
                   }&
    stub_request(:get, "https://3:mxit_money_api@api.mxitmoney.co.za/paymentsplatform/rest/v3/push/").to_return(:status => 200, :body => token_body, :headers => {})
  end

  context "new" do

    it "must post to mxit api requesting token" do
      MxitMoneyApi.new("3")
      assert_requested(:get, "https://3:mxit_money_api@api.mxitmoney.co.za/paymentsplatform/rest/v3/push/",
                       :headers => {'Accept'=>'application/json', 'User-Agent'=>'Ruby'})
    end

    it "must set the balance" do
      connection = MxitMoneyApi.new("3")
      connection.balance.should == 5000
    end

  end

  context "connect" do

    it "must return connection if has access_token" do
      connection = mock('MxitMoneyApi', balance: "123")
      MxitMoneyApi.should_receive(:new).with("3").and_return(connection)
      MxitMoneyApi.connect("3").should == connection
    end

    it "wont return connection if no balance" do
      connection = mock('MxitApi', balance: nil)
      MxitMoneyApi.should_receive(:new).with("3").and_return(connection)
      MxitMoneyApi.connect("3").should be_nil
    end

  end

  context "user_info" do

    before :each do
      @body = %&{ "isRegistered": true,
                 "loginName": "gbox21",
                 "mxitId": "m40000000000",
                 "msisdn": "27712345678"
                }&
      @connection = MxitMoneyApi.new("3")
    end

    it "must return a hash for search by mxitId" do
      stub_request(:get, "https://3:mxit_money_api@api.mxitmoney.co.za/paymentsplatform/rest/v3/user/m40000000000?idType=mxitId").
        with(:headers => {'Accept'=>'application/json', 'User-Agent'=>'Ruby'}).
        to_return(:status => 200, :body => @body, :headers => {})
      profile = @connection.user_info(:id => 'm40000000000')
      profile.should be_kind_of(Hash)
      profile[:is_registered].should == true
      profile[:login_name].should == "gbox21"
      profile[:mxit_id].should == "m40000000000"
      profile[:msisdn].should == "27712345678"
    end

    it "must return a hash for search by phoneNumber" do
      stub_request(:get, "https://3:mxit_money_api@api.mxitmoney.co.za/paymentsplatform/rest/v3/user/0712345678?idType=phoneNumber").
        with(:headers => {'Accept'=>'application/json', 'User-Agent'=>'Ruby'}).
        to_return(:status => 200, :body =>  @body, :headers => {})
      profile = @connection.user_info(:id => '0712345678', :id_type => :phone_number)
      profile.should be_kind_of(Hash)
      profile[:is_registered].should == true
      profile[:login_name].should == "gbox21"
      profile[:mxit_id].should == "m40000000000"
      profile[:msisdn].should == "27712345678"
    end

    it "must handle a failed response" do
      body = %&{
                 "errorType": "INVALID_MSISDN",
                 "message": "The phone number is incorrect."
                }&
      stub_request(:get, "https://3:mxit_money_api@api.mxitmoney.co.za/paymentsplatform/rest/v3/user/m40000000001?idType=mxitId").
        with(:headers => {'Accept'=>'application/json', 'User-Agent'=>'Ruby'}).
        to_return(:status => 500, :body => body, :headers => {})
      profile = @connection.user_info(:id => 'm40000000001')
      profile.should_not be_empty
    end

  end

  context "issue_money" do

    before :each do
      @body = %&{
                 "m2_reference": "886e797d-ff9b-4743-a6a6-908bf588b2f8"
                }&
      stub_request(:post, "https://3:mxit_money_api@api.mxitmoney.co.za/paymentsplatform/rest/v3/push/issue/0761234567?amountInCents=123&merchantReference=000000001").
        to_return(:status => 200, :body => @body, :headers => {})
      @connection = MxitMoneyApi.new("3")
    end

    it "must make the correct api request" do
      @connection.issue_money(:phone_number => "0761234567",
                              :merchant_reference => "000000001",
                              :amount_in_cents => "123")
      assert_requested(:post, "https://3:mxit_money_api@api.mxitmoney.co.za/paymentsplatform/rest/v3/push/issue/0761234567?amountInCents=123&merchantReference=000000001",
                       :headers => {'Accept'=>'application/json',
                                    'User-Agent'=>'Ruby',
                                    'Content-Type' =>'application/json'})
    end

    it "must handle a response" do
      profile = @connection.issue_money(:phone_number => "0761234567",
                                        :merchant_reference => "000000001",
                                        :amount_in_cents => "123")
      profile.should_not be_empty
    end

  end

end