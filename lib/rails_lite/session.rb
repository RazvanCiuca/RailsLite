require 'json'
require 'webrick'

class Session
  def initialize(req)
    req.cookies.each do |cookie|
      if cookie.name == '_rails_lite_app'
        @cookie = JSON.parse(cookie.value)
      end
    end
    @cookie = {} if @cookie.nil?
  end

  def [](key)
    @cookie[key]
  end

  def []=(key, val)
    @cookie[key] = val
  end

  def store_session(res)
    value = @cookie.to_json
    res.cookies << WEBrick::Cookie.new('_rails_lite_app', value)
  end
end
