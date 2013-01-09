class MxitMoneyApi

  def issue_money(params)
    params = Hash[params.map {|k, v| [k.to_s.camelize(:lower), v] }]
    url = URI.parse("https://m2api.fireid.com/paymentsplatform/rest/v3/push/issue/#{params.delete('phoneNumber')}?#{params.to_query}")
    req = Net::HTTP::Post.new(url.to_s,
                              'Accept'=>'application/json',
                              'Content-Type' =>'application/json')
    req.basic_auth(api_key,"mxit_money_api".to_s)
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    response = http.request(req)
    if response.code == '200' || response.code == '401' || response.code == '500' || response.code == '400'
      @balance = nil
      data = ActiveSupport::JSON.decode(response.body)
      HashWithIndifferentAccess.new(Hash[data.map {|k, v| [k.underscore, v] }])
    end
  end

end