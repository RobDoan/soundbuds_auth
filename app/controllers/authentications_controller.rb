require 'shopify_multipass';
class AuthenticationsController < ApplicationController

  def create
    omniauth = request.env['omniauth.auth']
    authentication = Authentication.find_by_provider_and_uid(omniauth['provider'], omniauth['uid'])
    if authentication
      flash[:notice] = 'Signed in successfully.'
      user = authentication.user
      sign_in(:user, user)
      token = ShopifyMultipass.new("6019ce563c5f880e3f3e43f31bbf55fc").generate_token(user.customer_shopify_data)
      redirect_to "https://soundbud-dev.myshopify.com/account/login/multipass/#{token}"
    else
      user = User.new
      user.apply_omniauth(omniauth)
      if user.save(:validate => false)
        flash[:notice] = 'Signed in successfully.'
        session[:new_user] = true
        sign_in(:user, user)
        token = ShopifyMultipass.new("6019ce563c5f880e3f3e43f31bbf55fc").generate_token(user.customer_shopify_data)
        redirect_to "https://soundbud-dev.myshopify.com/account/login/multipass/#{token}"
      else
        session[:omniauth] = omniauth.except('extra')
        flash[:error] = 'log in failure'
        redirect_to root_url
      end
    end
  end

end
