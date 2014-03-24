class MxitMoneyApi

  BASE_URL = 'https://api.mxitmoney.co.za'
  attr_reader :api_key, :balance

  def initialize(api_key)
    @api_key = api_key
    balance
  end

  def self.connect(*args)
    connection = new(*args)
    connection.balance ? connection : nil
  end

  def balance
    return @balance unless @balance.nil?
    url = URI.parse("#{BASE_URL}/paymentsplatform/rest/v3/push/")
    req = Net::HTTP::Get.new(url.path, 'Accept'=>'application/json')
    req.basic_auth(api_key, 'mxit_money_api')
    response = Net::HTTP.start(url.host, url.port,
                               :use_ssl => url.scheme == 'https',
                               :verify_mode => OpenSSL::SSL::VERIFY_NONE) do |https|
      https.request(req)
    end
    if response.code == '200'
      data = ActiveSupport::JSON.decode(response.body)
      @balance = data['balance']
    end
    @balance
  end

end
