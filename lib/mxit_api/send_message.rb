class MxitApi

  def send_message(params)
    params = Hash[params.map {|k, v| [k.to_s.camelize, v] }]
    params.reverse_merge!('ContainsMarkup' => 'true', 'From' => app_name)
    url = URI.parse('https://api.mxit.com/message/send/')
    req = Net::HTTP::Post.new(url.path,
                              'Authorization' => "#{token_type} #{access_token}",
                              'Accept'=>'application/json',
                              'Content-Type' =>'application/json')
    req.body = params.to_json
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    http.request(req)
  end

end
