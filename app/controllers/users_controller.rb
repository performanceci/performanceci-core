class UsersController < ApplicationController
  layout 'login'

  def local_login
    redirect_to root_url unless Rails.env == 'development'
    sign_in(:user, User.find(params[:id]))
    redirect_to root_url
  end
end