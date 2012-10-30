class MxitApi

  attr_reader :access_token, :token_type, :refresh_token, :scope, :expire_at, :app_name

  def initialize(client_id, client_secret, form_data = {grant_type: 'client_credentials', scope: 'message/send'})
    if form_data.kind_of?(Hash)
      url = URI.parse('https://auth.mxit.com/token')
      req = Net::HTTP::Post.new(url.path, 'Accept'=>'application/json')
      req.set_form_data(form_data)
      req.basic_auth(client_id,client_secret)
      http = Net::HTTP.new(url.host, url.port)
      http.use_ssl = true
      response = http.request(req)
      if response.code == '200'
        data = ActiveSupport::JSON.decode(response.body)
        @access_token = data['access_token']
        @token_type = data['token_type']
        @refresh_token = data['refresh_token']
        @scope = data['scope']
        @expire_at = data['expires_in'].to_i.seconds.from_now
      end
    end
  end

  def self.connect(*args)
    connection = new(*args)
    connection.access_token ? connection : nil
  end

end