MxitApi gem for API connections to mxit
=================================

This gem allows you to easily interact (http://dev.mxit.com/docs/):
* Authorization API (OAuth 2.0)
* Messaging API
* User API

Installation
============

Place this in your Gemfile:
```ruby
gem 'mxit_api'
```
and run the bundle command or type this in the command line:

```
gem install mxit_api
```

Then try one of the examples below.

Examples
========

Prerequisites (usually found on the mxit dashboard http://code.mxit.com/MobiDashboard/Default.aspx):
* ruby 1.9.2
* mxit client id
* mxit secret id


Messaging
----------------
http://dev.mxit.com/docs/api/messaging/post-message-send

```ruby
 connection = MxitApi.new(client_id, client_secret, {grant_type: 'client_credentials', scope: 'message/send'})
 connection.send_message(to: "m123,m345", from: "yourappname", body: "This is a mxit message")
```  

User Profile
----------------
http://dev.mxit.com/docs/authentication#OAuth2_Flows
http://dev.mxit.com/docs/api/user/get-user-profile

```ruby
   connection = MxitApi.new(client_id, client_secret, {:grant_type => 'authorization_code',
                                                       :code => "code from authentication",
                                                       :redirect_uri => "http://you.host/redirect/url")
   result = connection.profile
   result[:display_name] 
   result[:gender] 
   # etc

```
