# For now, this class makes it possible to use asset_package with Heroku.
# Later, I'll figure out a way to DRY this and config/asset_packages.yml up.
module AssetsHelper
  
  def js_assets
    if Rails.env.production?
      ['http://ajax.googleapis.com/ajax/libs/jquery/1.4.2/jquery.min.js', 'merged_packaged']
    else
      ['jquery-1.3.2.min', 'application', 'jQuery-highlightFade.0.7']
    end
  end
  
  def css_assets
    if Rails.env.production?
      ['merged_packaged']
    else
      ['reset', 'application', 'credentials', 'sidebar']
    end
  end
  
end
