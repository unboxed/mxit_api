class MxitApi
  def user_id
    url = URI.parse('https://auth.mxit.com/userinfo?schema=openid')
    req = Net::HTTP::Get.new('/userinfo?schema=openid',
                              'Authorization' => "#{token_type} #{access_token}",
                              'Accept'=>'application/json',
                              'Content-Type' =>'application/json')
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    response = http.request(req)
    if response.code == '200'
      data = ActiveSupport::JSON.decode(response.body)
      data['sub']
    end
  end
end
