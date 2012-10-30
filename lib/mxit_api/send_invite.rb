class MxitApi

  def send_invite(contact)
    url = URI.parse("https://api.mxit.com/user/socialgraph/contact/#{contact}")
    req = Net::HTTP::Put.new(url.path, 'Authorization' => "#{token_type} #{access_token}", 'Accept'=>'application/json')
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    http.request(req)
  end

end