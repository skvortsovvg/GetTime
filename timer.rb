require 'logger'
require 'uri'

# # year, month, day, hour, minute, second
# # 1970-01-01 23:59:59
# # '%Y-%m-%d %H:%M:%S'

class App
  
  DATE = { year: "%Y", month: "%m", day: "%d" }  
  TIME = { hour: "%H", minute: "%M", second: "%S" }  
  
  def call(env)
    return error_result unless env['PATH_INFO'].include?('/time')
    current_time(env['QUERY_STRING']) 
  end

private

  def error_result
    [
      404, 
      headers,
      ["404\n Ooops!\n Bad request"]
    ]
  end

  def current_time(time_request)
    
    result = []   
    params =  URI.decode_www_form(time_request).assoc('format');
    return error_result if params.nil?
    
    params = params.last.split(',').map(&:to_sym)
    unknown = params.select { |key| !(TIME.keys.include?(key) || DATE.keys.include?(key)) }  
    
    return [
          400, 
          headers, 
          unknown.map { |f| "Unknown time format '#{f}'\n" }
          ] if unknown.any?

    result << DATE.select { |key, value| params.include?(key) }.values.join("-")
    result << TIME.select { |key, value| params.include?(key) }.values.join(":")

    [ 
      200,
      headers,
      [Time.now.strftime(result.join(' '))]
    ]
  end

  def headers
    { 'Content-Type' => 'text/plain'}
  end

end
