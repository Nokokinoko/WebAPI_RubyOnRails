module TraitUser
  extend ActiveSupport::Concern
  
  included do
    # --- Id ---
    def id
      render status: :bad_request unless required_parameter?('guid')
      
      user = User.find_by(guid: params['guid'])
      render status: :bad_request if user.nil? || user.deleted_ymd != 0
      
      @@response_code = :ok # rubocop:disable Style/ClassVars
      render json: { id: user.id }, status: @@response_code
    end
    
    # --- Regist ---
    def regist
      render status: :bad_request unless required_parameter?(['guid', 'os', 'ver', 'model', 'lang'])
      
      user = User.find_by!(guid: params['guid'])
      if user.nil?
        # create user
        user.new(
          guid: params['guid'],
          os: params['os'],
          ver: params['ver'],
          model: params['model'],
          lang: params['lang'],
          created_at: now() # rubocop:disable Style/MethodCallWithoutArgsParentheses
        )
        
        begin
          User.transaction do
            raise 'Failed save' unless user.save!
          end
        rescue StandardError => e
          identification = identification()
          logger.error("[#{identification}] /user/regist Message:#{e} Log:#{params.to_json}")
        end
      else
        # exist user
        render status: :bad_request if user.deleted_ymd != 0 # rubocop:disable Style/IfInsideElse
      end
      
      @@response_code = :ok # rubocop:disable Style/ClassVars
      render json: { id: user.id }, status: @@response_code
    end
    
    # --- Delete ---
    def delete
      render status: :bad_request unless required_parameter?(['id', 'guid', 'hash'])
      
      user = User.find(params['id'])
      render status: :bad_request if user.nil?
      
      hashed = Digest::SHA256.hexdigest(user.model)
      render status: :bad_request if !user.guid.eql?(params['guid']) || !hashed.eql?(params['hash'])
      
      if user.deleted_ymd.zero?
        user.deleted_ymd = ymd() # rubocop:disable Style/MethodCallWithoutArgsParentheses
        
        begin
          User.transaction do
            raise 'Failed delete' unless user.save!
          end
        rescue StandardError => e
          identification = identification()
          logger.error("[#{identification}] /user/delete Message:#{e} Log:#{params.to_json}")
        end
      end
      
      @@response_code = 200 # rubocop:disable Style/ClassVars
      render json: { deleted: 1 }, status: @@response_code
    end
  end
end
