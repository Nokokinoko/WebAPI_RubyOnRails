class DevelopController < AbstractController
  include TraitNft
  include TraitApi
  include TraitUser
  
  protected
  
  # override
  def fqgn
    'com.example_studio.example_qgn'
  end
  
  # override
  def identification
    'dev'
  end
  
  private
  
  # override TraitNft
  def url_base
    # Staging only
    URL_STAGING
  end
end
