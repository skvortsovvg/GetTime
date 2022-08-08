# # year, month, day, hour, minute, second
# # 1970-01-01 23:59:59
# # '%Y-%m-%d %H:%M:%S'
class TimeFormatter

  DATE = { year: "%Y", month: "%m", day: "%d" }  
  TIME = { hour: "%H", minute: "%M", second: "%S" }  
  
  attr_reader :error

  def initialize(params)
    @params = params.split(',').map { |param| param.strip.to_sym }
    @error = nil
    validate
  end

  def success?
    @error.nil?
  end

  def get_date
    Time.now.strftime(DATE.select { |key, value| @params.include?(key) }.values.join("-"))
  end
  
  def get_time
    Time.now.strftime(TIME.select { |key, value| @params.include?(key) }.values.join(":"))
  end 

  def get_date_time
    "#{get_date} #{get_time}"
  end

  def valid_params
   DATE.keys + TIME.keys     
  end

private 

 def validate
    unknown = @params.select { |key| !valid_params.include?(key) }  
    @error = unknown.map { |f| "Unknown time format '#{f}'\n" }.join if unknown.any?
  end

end
