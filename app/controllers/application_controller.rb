class ApplicationController < ActionController::Base
  before_action :access_log
  before_action :check_request
  
  private
  def access_log
    format = "time:#{Time.now.to_s}, " +
      "remote_ip:#{request.remote_ip}, " +
      "user_agent:#{request.user_agent}" +
      "url:#{request.url}"
    Application.config.access_logger.info(format)
  end
  
  def check_request
    if request.content_type != 'application/json'
      render status: :method_not_allowed
    end
    
    while false
      if ENV.has_key?('docker')
        break
      end
      
      my_header = request.headers['X-MyHeader']
      if my_header == 'MyHeaderCode'
        break
      end
      
      allow = [
        '0.0.0.0',
      ]
      if allow.include?(request.remote_ip)
        break
      end
      
      render status: :method_not_allowed
    end
  end
end
