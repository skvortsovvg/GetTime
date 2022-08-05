require_relative 'time_formatter'

class App
  
  def call(env)
    time_srv = TimeFormatter.new
    time_srv.call(env['REQUEST_URI'])
  
    answer(time_srv.result, time_srv.status)
  end

private

  def answer(body, status = 200)
    Rack::Response.new(body, status, headers).finish
  end

  def headers
    { 'Content-Type' => 'text/plain'}
  end

end