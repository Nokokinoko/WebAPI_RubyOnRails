require 'json'

module TraitApi
  extend ActiveSupport::Concern
  
  included do
    public
    # --- Version Check ---
    def version
      message = '1.0' // TODO: parameter store
      @@response_code = 200
      render plain: message, status: @@response_code
    end
    
    # --- Log ---
    def log
      logger.error('[' + identification() + '] Log:' + params.to_json)
      @@response_code = 200
      render plain: '', status: @@response_code
    end
  end
end
