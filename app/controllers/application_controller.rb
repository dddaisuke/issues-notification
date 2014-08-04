class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :check_oauth_token

  def push_issue_close(params)
    Pusher['issue'].trigger('close', {
      params: params
    })
  end

  def push_issue(action, params)
    Pusher['issue'].trigger(action, params)
  end

  def check_oauth_token
    redirect_to '/auth/github' unless session[:github_token]
  end
end
