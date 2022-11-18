require 'net/http'
require 'json'

module TraitNft
  extend ActiveSupport::Concern
  
  included do
    public
    # TODO: setting url
    URL_PRODUCTION = 'https://production'
    URL_STAGING = 'https://staging'
    
    private
    def make_fields(*keys)
      fields = {}
      keys.each{|val| fields[val] = params[val]}
      return fields
    end
    
    def url_base
      params['stg'].present? && ENV['docker'].present? ? URL_STAGING : URL_PRODUCTION
    end
    
    # cURL >>>
    def curl_get(query, debug_response)
      if params['disconn'].present? || ENV['docker'].present?
        message = {
          disconn: true,
          server_uri: request.fullpath,
          request_uri: url_base + query,
          response: debug_response
        }
        @@response_code = 200
      else
        uri = URI.parse(url_base + query)
        result = Net::HTTP.get_response(uri)
        message = result.body
        @@response_code = result.code.to_i
      end
      
      return message.to_json
    end
    
    def curl_post(query, fields, debug_response)
      if params['disconn'].present? || ENV['docker'].present?
        message = {
          disconn: true,
          server_uri: request.fullpath,
          request_uri: url_base + query,
          fields: fields.to_json,
          response: debug_response
        }
        @@response_code = 200
      else
        uri = URI.parse(url_base + query)
        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true
        result = http.post(uri.path, fields.to_json, {'X-Auth-Key' => 'app_auth'}) # TODO: parameter store
        message = result.body
        @@response_code = result.code.to_i
      end
      
      return message.to_json
    end
    # <<< cURL
    
    public
    # --- Balance ---
    def balance
      query = "/user/#{params['address']}/balance"
      load './debug_response/debug_balance.rb'
      render json: curl_get(query, debug_response), status: @@response_code
    end
    
    # --- List Collections ---
    def list_collections
      query = "/collections/" + fqgn() + "/"
      load './debug_response/debug_list_collections.rb'
      render json: curl_get(query, debug_response), status: @@response_code
    end
    
    # --- Collection Detail ---
    def collection_detail
      query = "/collections/" + fqgn() + "/#{params['qCn']}"
      load './debug_response/debug_collection_detail.rb'
      render json: curl_get(query, debug_response), status: @@response_code
    end
    
    # --- Clone ---
    def clone
      query = "/tokens/manage/#{params['fqTn']}/clone"
      fields = make_fields('to', 'mutableProperties', 'cloneMutableProperties', 'displayInDiscovery')
      load './debug_response/debug_clone.rb'
      render json: curl_post(query, fields, debug_response), status: @@response_code
    end
    
    # --- Mint ---
    def mint
      query = "/tokens/manage/#{params['fqTn']}/mint"
      fields = make_fields('to', 'amount')
      load './debug_response/debug_mint.rb'
      render json: curl_post(query, fields, debug_response), status: @@response_code
    end
    
    # --- Burn ---
    def burn
      query = "/tokens/manage/burn"
      fields = make_fields('from', 'fqTn', 'quantity')
      load './debug_response/debug_burn.rb'
      render json: curl_post(query, fields, debug_response), status: @@response_code
    end
    
    # --- Burn to Mint ---
    def burn_to_mint
      query = "/tokens/manage/burn-to-mint"
      fields = make_fields('address', 'fqCn', 'burnTokens', 'mintTokens')
      load './debug_response/debug_burn_to_mint.rb'
      render json: curl_post(query, fields, debug_response), status: @@response_code
    end
    
    # --- Transfer ---
    def transfer
      query = "/tokens/manage/transfer"
      fields = make_fields('to', 'fqCn', 'tokens')
      load './debug_response/debug_transfer.rb'
      render json: curl_post(query, fields, debug_response), status: @@response_code
    end
    
    # --- List Tokens ---
    def list_tokens
      query = "/tokens/" + fqgn() + "/"
      load './debug_response/debug_list_tokens.rb'
      render json: curl_get(query, debug_response), status: @@response_code
    end
    
    # --- List Tokens by Collection ---
    def list_tokens_by_collection
      query = "/tokens/" + fqgn() + "/#{params['qCn']}/"
      load './debug_response/debug_list_tokens.rb'
      render json: curl_get(query, debug_response), status: @@response_code
    end
    
    # --- Tokens Detail ---
    def token_detail
      query = "/tokens/" + fqgn() + "/#{params['qCn']}/#{params['qTn']}"
      load './debug_response/debug_token_detail.rb'
      render json: curl_get(query, debug_response), status: @@response_code
    end
    
    # --- List User Tokens ---
    def list_user_tokens
      query = "/user/#{params['address']}/tokens/" + fqgn() + "/"
      load './debug_response/debug_list_user_tokens.rb'
      render json: curl_get(query, debug_response), status: @@response_code
    end
    
    # --- List User Tokens by Collection ---
    def list_user_tokens_by_collection
      query = "/user/#{params['address']}/tokens/" + fqgn() + "/#{params['qCn']}/"
      load './debug_response/debug_list_user_tokens.rb'
      render json: curl_get(query, debug_response), status: @@response_code
    end
    
    # --- User Token Detail ---
    def user_token_detail
      query = "/user/#{params['address']}/tokens/" + fqgn() + "/#{params['qCn']}/#{params['qTn']}"
      load './debug_response/debug_user_token_detail.rb'
      render json: curl_get(query, debug_response), status: @@response_code
    end
    
    # --- List Users by Token ---
    def list_user_by_token
      query = "/users/" + fqgn() + "/#{params['qCn']}/#{params['qTn']}/"
      load './debug_response/debug_list_users_by_token.rb'
      render json: curl_get(query, debug_response), status: @@response_code
    end
  end
end
