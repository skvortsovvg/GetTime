require 'uri'

# # year, month, day, hour, minute, second
# # 1970-01-01 23:59:59
# # '%Y-%m-%d %H:%M:%S'
class TimeFormatter

  DATE = { year: "%Y", month: "%m", day: "%d" }  
  TIME = { hour: "%H", minute: "%M", second: "%S" }  

  attr_reader :status, :result
  attr_accessor :query

  def initialize
    @status = 404
    @query = ""
    @result = ""
    @params = []
  end

  def call(query = nil)
    @query = query if query
    get_date_time if parse_validate
    @result
  end

private

  def parse_validate()
    
    uri = URI.parse(@query)
    params = URI.decode_www_form(uri.query).assoc('format')

    unless uri.path.include?('/time') && params
      @result = "404\n Ooops!\n Bad request"
      @status = 404 
      return false
    end

    @params = params.last.split(',').map(&:to_sym)
    unknown = @params.select { |key| !valid_params.include?(key) }  
    if unknown.any?
      @result = unknown.map { |f| "Unknown time format '#{f}'\n" }.join
      @status = 400
      return false
    end

    return true
  end

  def get_date()
    Time.now.strftime(DATE.select { |key, value| @params.include?(key) }.values.join("-"))
  end
  
  def get_time()
    Time.now.strftime(TIME.select { |key, value| @params.include?(key) }.values.join(":"))
  end 

  def get_date_time()
    @result = "#{get_date} #{get_time}".strip    
  end

  def valid_params
   DATE.keys + TIME.keys     
  end
end
