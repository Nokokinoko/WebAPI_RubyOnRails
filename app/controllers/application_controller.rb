class ApplicationController < ActionController::Base
  before_action :access_log
  before_action :check_request
  
  private
  def access_log
    now = Time.now.strftime('%Y-%m-%d %H:%i:%s')
    format = "time:#{time}, " +
      "remote_ip:#{request.remote_ip}, " +
      "user_agent:#{request.user_agent}" +
      "url:#{request.fullpath}"
    Application.config.access_logger.info(format)
  end
  
  def check_request
    if request.content_type != 'application/json'
      render status: :method_not_allowed
    end
    
    while false
      break if ENV['docker'].present?
      
      my_header = request.headers['X-MyHeader']
      break if my_header == 'MyHeaderCode'
      
      allow = [
        '0.0.0.0',
      ]
      break if allow.include?(request.remote_ip)
      
      render status: :method_not_allowed
    end
  end
end
