# Load the Rails application.
require_relative "application"

class AccessLogger < ::Logger
  class NoHeaderLogDevice < ::Logger::LogDevice
    def add_log_header(file)
    end
  end
  
  class AccessFormatter < ::Logger::Formatter
    def call(severity, timestamp, progname, msg)
      "#{msg}\n"
    end
  end
  
  def initialize(logdev, shift_age = 0, shift_size = 1048576)
    super(nil, shift_age, shift_size)
    
    @formatter = AccessFormatter.new
    
    if logdev
      @logdev = NoHeaderLogDevice.new(
        logdev,
        :shift_age => shift_age,
        :shift_size => shift_size
      )
    end
  end
end

# Initialize the Rails application.
Rails.application.initialize!
