require 'json'

module TraitApi
  extend ActiveSupport::Concern
  
  included do
    # --- Version Check ---
    def version
      message = '1.0' # TODO: parameter store
      @@response_code = :ok # rubocop:disable Style/ClassVars
      render plain: message, status: @@response_code
    end
    
    # --- Log ---
    def log
      identification = identification()
      logger.error("[#{identification}] Log:#{params.to_json}")
      @@response_code = :ok # rubocop:disable Style/ClassVars
      render plain: '', status: @@response_code
    end
  end
end
