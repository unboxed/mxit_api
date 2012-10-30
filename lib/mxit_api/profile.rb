class MxitApi

  def profile
    profile = {}
    url = URI.parse('https://api.mxit.com/user/profile')
    req = Net::HTTP::Get.new(url.path, 'Authorization' => "#{token_type} #{access_token}", 'Accept'=>'application/json')
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    response = http.request(req)
    if response.code == '200'
      data = ActiveSupport::JSON.decode(response.body)
      profile = Hash[data.map {|k, v| [k.underscore, v] }]
    end
    HashWithIndifferentAccess.new(profile)
  end

end