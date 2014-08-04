class SessionsController < ApplicationController
  skip_before_filter :check_oauth_token

  def create
    session[:github_token] = request.env['omniauth.auth'].credentials.token
    redirect_to root_path
  end
end
