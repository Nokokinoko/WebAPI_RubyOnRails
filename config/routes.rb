Rails.application.routes.draw do
  dict = { dev: 'develop' }
  
  dict.each do |key, val|
    scope key do
      scope :nft do
        post 'balance', to: "#{val}#balance"
        post 'list_collections', to: "#{val}#list_collections"
        post 'collection_detail', to: "#{val}#collection_detail"
        post 'clone', to: "#{val}#clone"
        post 'mint', to: "#{val}#mint"
        post 'burn', to: "#{val}#burn"
        post 'burn_to_mint', to: "#{val}#burn_to_mint"
        post 'transfer', to: "#{val}#transfer"
        post 'list_tokens', to: "#{val}#list_tokens"
        post 'list_tokens_by_collection', to: "#{val}#list_tokens_by_collection"
        post 'token_detail', to: "#{val}#token_detail"
        post 'list_user_tokens', to: "#{val}#list_user_tokens"
        post 'list_user_tokens_by_collection', to: "#{val}#list_user_tokens_by_collection"
        post 'user_token_detail', to: "#{val}#user_token_detail"
        post 'list_users_by_token', to: "#{val}#list_users_by_token"
      end
      
      post 'ver', to: "#{val}#version"
      post 'log', to: "#{val}#log"
      
      scope :user do
        post 'id', to: "#{val}#id"
        post 'regist', to: "#{val}#regist"
        post 'delete', to: "#{val}#delete"
      end
    end
  end
end
