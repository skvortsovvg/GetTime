require 'logger'
require 'uri'
require_relative 'time_formatter'

class App
  
  def call(env)
    params =  URI.decode_www_form(env['QUERY_STRING']).assoc('format');
    return answer("404\n Ooops!\n Bad request", 404) unless env['PATH_INFO'].include?('/time') && params
    
    params = params.last.split(',').map(&:to_sym)
    unknown = params.select { |key| !TimeFormatter.valid_params.include?(key) }  
    return answer(unknown.map { |f| "Unknown time format '#{f}'\n" }, 400) if unknown.any?

    answer(TimeFormatter.get_date_time(params))
  end

private

  def answer(body, status = 200)
    Rack::Response.new(body, status, headers).finish
  end

  def headers
    { 'Content-Type' => 'text/plain'}
  end

end
