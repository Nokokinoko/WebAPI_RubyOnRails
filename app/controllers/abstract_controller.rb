class AbstractController < ApplicationController
  @@response_code = 0
  
  protected
  def fqgn
    raise RuntimeError
  end
  
  def identification
    raise RuntimeError
  end
  
  def has_required_parameter?(key)
    if key.instance_of?(String)
      return true if params[key].present?
    end
    
    if key.instance_of?(Array)
      key.each{|val|
        break unless has_required_parameter?(val)
        
        return true
      }
    end
    
    return false
  end
  
  def now
    Time.now.strftime('%Y-%m-%d %H:%i:%s')
  end
  
  def ymd
    Time.now.strftime('%Y%m%d')
  end
end
