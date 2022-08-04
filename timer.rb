require 'logger'
require 'uri'
require 'rack'

# # year, month, day, hour, minute, second
# # 1970-01-01 23:59:59
# # '%Y-%m-%d %H:%M:%S'

class TimeFormatter

  DATE = { year: "%Y", month: "%m", day: "%d" }  
  TIME = { hour: "%H", minute: "%M", second: "%S" }  
  
  def self.get_date(params)
    Time.now.strftime(DATE.select { |key, value| params.include?(key) }.values.join("-"))
  end
  
  def self.get_time(params)
    Time.now.strftime(TIME.select { |key, value| params.include?(key) }.values.join(":"))
  end 

  def self.get_date_time(params)
    "#{self.get_date(params)} #{self.get_time(params)}"    
  end

  def self.valid_params
   DATE.keys + TIME.keys     
  end
end

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