module TraitUser
  extend ActiveSupport::Concern
  
  included do
    public
    # --- Id ---
    def id
      unless has_required_parameter?('guid')
        render status: :bad_request
      end
      
      @@response_code = :ok
      render json: {id: 0}, status: @@response_code
    end
    
    # --- Regist ---
    def regist
      unless has_required_parameter?(['guid', 'os', 'ver', 'model', 'lang'])
        render status: :bad_request
      end
      
      created = 0
      @@response_code = :ok
      render json: {id: created}, status: @@response_code
    end
    
    # --- Delete ---
    def delete
      unless has_required_parameter?(['id', 'guid', 'hash'])
        render status: :bad_request
      end
      
      deleted = 0
      @@response_code = 200
      render json: {deleted: deleted}, status: @@response_code
    end
  end
end
