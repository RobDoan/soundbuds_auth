Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, '355907081172865', '7f95c2db9d1cdf1cf8c0163d5ab6003a'
  provider :google_oauth2, '771587125701.apps.googleusercontent.com', 'XPSLHOv8mGi-Mw4cTuvBcM9o'

  provider :shopify,
           ShopifyApp.configuration.api_key, 
           ShopifyApp.configuration.secret,

           # Example permission scopes - see http://docs.shopify.com/api/tutorials/oauth for full listing
           :scope => 'read_orders, read_products',

           :setup => lambda {|env| 
                       params = Rack::Utils.parse_query(env['QUERY_STRING'])
                       site_url = "https://#{params['shop']}"
                       env['omniauth.strategy'].options[:client_options][:site] = site_url
                     }
end
