require 'uri'

class Params
  def initialize(req, route_params)
    @params = route_params
    parse_www_encoded_form(req.query_string)
    parse_www_encoded_form(req.body)
  end

  def [](key)
    @params[key]
  end

  def to_s
    @params.to_s
  end

  private
  def parse_www_encoded_form(www_encoded_form)
    return if www_encoded_form.nil?
    query_pairs = URI.decode_www_form(www_encoded_form)
    query_pairs.each do |key, val|
      nested_keys = parse_key(key)
      nest_key(nested_keys, val)
    end
  end

  def parse_key(key)
    key.scan(/\w+/)
  end

  def nest_key(nested_keys, val)
    until nested_keys.empty?
      key = nested_keys.shift
      if p.has_key?(key)
        p = p[key]
      else
        if nested_keys.empty?
          p[key] = val
        else
          p[key] = {}
          p = p[key]
        end
      end
    end
  end
end
