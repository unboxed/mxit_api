class MxitMoneyApi

  def issue_money(params)
    params = Hash[params.map {|k, v| [k.to_s.camelize(:lower), v] }]
    url = URI.parse("https://m2api.fireid.com/paymentsplatform/rest/v3/push/issue/#{params.delete('phoneNumber')}?#{params.to_query}")
    req = Net::HTTP::Post.new(url.to_s,
                              'Accept'=>'application/json',
                              'Content-Type' =>'application/json')
    req.basic_auth(api_key,"mxit_money_api".to_s)
    response = Net::HTTP.start(url.host, url.port,
                               :use_ssl => url.scheme == 'https',
                               :verify_mode => OpenSSL::SSL::VERIFY_NONE) do |https|
      https.request(req)
    end
    if response.code == '200' || response.code == '401' || response.code == '500' || response.code == '400'
      @balance = nil
      data = ActiveSupport::JSON.decode(response.body)
      HashWithIndifferentAccess.new(Hash[data.map {|k, v| [k.underscore, v] }])
    end
  end

end