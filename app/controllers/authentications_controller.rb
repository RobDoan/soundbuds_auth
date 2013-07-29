require 'shopify_multipass';
class AuthenticationsController < ApplicationController

  def create
    omniauth = request.env['omniauth.auth']
    authentication = Authentication.find_by_provider_and_uid(omniauth['provider'], omniauth['uid'])
    if authentication
      flash[:notice] = 'Signed in successfully.'
      user = authentication.user
      sign_in(:user, user)
      login_shopify_token_link(user)
    else
      user = User.new
      user.apply_omniauth(omniauth)
      if user.save(:validate => false)
        flash[:notice] = 'Signed in successfully.'
        session[:new_user] = true
        sign_in(:user, user)
        redirect_to login_shopify_token_link(user)
      else
        session[:omniauth] = omniauth.except('extra')
        flash[:error] = 'log in failure'
        redirect_to root_url
      end
    end
  end

  protected
  def login_shopify_token_link(user)
    token = ShopifyMultipass.new(ShopConfig.mulit_pass_key).generate_token(user.customer_shopify_data)
    "#{ShopConfig.shopify_login_url}#{token}"
  end

end
