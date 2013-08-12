class Route
  attr_reader :pattern, :method, :controller, :action

  def initialize(pattern, http_method, controller_class, action_name)
    @pattern, @method, @controller, @action = pattern, http_method, controller_class, action_name
  end

  def matches?(req)
    return false unless req.request_method.downcase.to_sym == @method
    return false if req.path.scan(@pattern).empty?
    true
  end

  def run(req, res)
    @controller.new(req, res).invoke_action(action)
  end
end

class Router
  attr_reader :routes
  [:get, :post, :put, :delete].each do |http_method|
    define_method("#{http_method}") do |pattern,controller,action|
      add_route(pattern, http_method, controller, action)
    end
  end


  def initialize
    @routes = []
  end

  def add_route(pattern, method, controller_class, action_name)
    @routes << Route.new(pattern, method, controller_class, action_name)
  end

  def draw(&proc)
    proc.call
  end

  def match(req)
    @routes.each do |route|
      return route if route.matches?(req)
    end
    nil
  end

  def run(req, res)
    route = self.match(req)
    if route
      route.run(req, res)
    else
      res.status = 404
    end
  end
end
