class ApplicationController < ActionController::Base
  before_action :access_log
  before_action :check_request
  
  private
  
  def access_log
    now = Time.current.strftime('%Y-%m-%d %H:%i:%s')
    format = "time:#{now}, " \
      "remote_ip:#{request.remote_ip}, " \
      "user_agent:#{request.user_agent}" \
      "url:#{request.fullpath}"
    Application.config.access_logger.info(format)
  end
  
  def check_request
    render status: :method_not_allowed unless request.content_type == 'application/json'
    
    render status: :method_not_allowed unless allow_request?
  end
  
  def allow_request?
    return true if ENV['docker'].present?
    
    my_header = request.headers['X-MyHeader']
    return true if my_header == 'MyHeaderCode'
    
    allow = [
      '0.0.0.0'
    ]
    return true if allow.include?(request.remote_ip)
    
    false
  end
end
