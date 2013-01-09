class MxitMoneyApi

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
    url = URI.parse('https://m2api.fireid.com/paymentsplatform/rest/v3/push/')
    req = Net::HTTP::Get.new(url.path, 'Accept'=>'application/json')
    req.basic_auth(api_key,"mxit_money_api")
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    response = http.request(req)
    if response.code == '200'
      data = ActiveSupport::JSON.decode(response.body)
      @balance = data['balance']
    end
    @balance
  end

end