# This file is used by Rack-based servers to start the application.

require_relative "middlewares/logger"
require_relative "timer"

# use Log
run App.new
