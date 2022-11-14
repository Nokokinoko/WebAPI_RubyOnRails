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
      if params[key].present?
        return true
      end
    end
    
    if key.instance_of?(Array)
      key.each{|val|
        if !has_required_parameter?(val)
          break
        end
        
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