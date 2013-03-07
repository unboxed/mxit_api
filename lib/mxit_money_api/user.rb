class MxitMoneyApi

  def user_info(params)
    params.symbolize_keys!
    url = URI.parse("#{BASE_URL}/paymentsplatform/rest/v3/user/#{params[:id]}?idType=#{(params[:id_type] || 'mxit_id').to_s.camelize(:lower)}")
    req = Net::HTTP::Get.new(url.to_s, 'Accept'=>'application/json')
    req.basic_auth(api_key,"mxit_money_api".to_s)
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    response = http.request(req)
    if response.code == '200' || response.code == '401' || response.code == '500' || response.code == '400'
      data = ActiveSupport::JSON.decode(response.body)
      HashWithIndifferentAccess.new(Hash[data.map {|k, v| [k.underscore, v] }])
    end
  end

end