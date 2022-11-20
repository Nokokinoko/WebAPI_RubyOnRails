class AbstractController < ApplicationController
  @@response_code = 0 # rubocop:disable Style/ClassVars
  
  protected
  
  def fqgn
    raise RuntimeError
  end
  
  def identification
    raise RuntimeError
  end
  
  def required_parameter?(key)
    return true if key.instance_of?(String) && params[key].present?
    
    if key.instance_of?(Array)
      key.each { |val| return false unless required_parameter?(val) }
      
      return true
    end
    
    false
  end
  
  def now
    Time.current.strftime('%Y-%m-%d %H:%i:%s')
  end
  
  def ymd
    Time.current.strftime('%Y%m%d')
  end
end
