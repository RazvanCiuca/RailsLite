require 'erb'
require_relative 'params'
require_relative 'session'
require 'active_support/core_ext'

class ControllerBase
  attr_reader :params

  def initialize(req, res, route_params = nil)
    @req, @res, @params = req, res, route_params
    @already_rendered = false
    @response_built = false
    @params = Params.new(req, route_params)
  end

  def session
    @session ||= Session.new(@req)
  end

  def already_rendered?
    @already_rendered
  end

  def redirect_to(url)
    @res.status = 302
    @res.header['location'] = "http://" + url
    @response_built = true
    session.store_session(@res)
  end

  def render_content(content, type)
    @res.content_type = type
    @res.body = content
    @already_rendered = true
    session.store_session(@res)
  end

  def render(template_name)
    file = File.read(Dir.pwd + "/views/#{self.class.to_s.underscore}/#{template_name}.html.erb")
    template = ERB.new(file)
    current_variables = binding
    result = template.result(current_variables)
    render_content(result, 'text/text')
  end

  def invoke_action(name)
    self.send(name)
    render name.to_sym unless @already_rendered
  end
end
