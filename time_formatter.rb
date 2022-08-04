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
    "#{get_date(params)} #{get_time(params)}"    
  end

  def self.valid_params
   DATE.keys + TIME.keys     
  end
end
