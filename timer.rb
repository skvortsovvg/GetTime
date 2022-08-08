require 'uri'
require_relative 'time_formatter'

class App
  
  def call(env)
  
    uri = URI.parse(env['REQUEST_URI'])
    params = URI.decode_www_form(uri.query).assoc('format') if uri.query
    return answer("404\n Ooops!\n Bad request", 404) unless uri.path.include?('/time') && params

    tf = TimeFormatter.new(params.last)
    return tf.success? ? answer(tf.get_date_time) : answer(tf.error, 400)
  
  end

private

  def answer(body, status = 200)
    Rack::Response.new(body, status, headers).finish
  end

  def headers
    { 'Content-Type' => 'text/plain'}
  end

end
