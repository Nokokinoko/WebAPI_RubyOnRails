module TraitUser
  extend ActiveSupport::Concern
  
  included do
    # --- Id ---
    def id
      render status: :bad_request unless required_parameter?('guid')
      
      @@response_code = :ok # rubocop:disable Style/ClassVars
      render json: { id: 0 }, status: @@response_code
    end
    
    # --- Regist ---
    def regist
      render status: :bad_request unless required_parameter?(['guid', 'os', 'ver', 'model', 'lang'])
      
      created = 0
      @@response_code = :ok # rubocop:disable Style/ClassVars
      render json: { id: created }, status: @@response_code
    end
    
    # --- Delete ---
    def delete
      unless required_parameter?(['id', 'guid', 'hash'])
        render status: :bad_request
      end
      
      deleted = 0
      @@response_code = 200 # rubocop:disable Style/ClassVars
      render json: { deleted: deleted }, status: @@response_code
    end
  end
end
