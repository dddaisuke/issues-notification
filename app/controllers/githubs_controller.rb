class GithubsController < ApplicationController
  skip_before_filter :verify_authenticity_token
  skip_before_filter :check_oauth_token

  def webhook
    issue = params[:issue]
    if !issue || issue[:pull_request] || params[:comment]
      return render text: ''
    end

    assignee = issue[:assignee]
    if assignee
      sender_name = assignee[:login]
      sender_avatar_url = assignee[:avatar_url]
    else
      sender_name = issue[:user][:login]
      sender_avatar_url = issue[:user][:avatar_url]
    end

    pusher_params = {
      state: issue[:state],
      number: issue[:number],
      sender_name: sender_name,
      sender_avatar_url: sender_avatar_url,
      title: issue[:title],
      url: issue[:html_url],
      owner_name: issue[:user][:login],
      closed_at: I18n.l(Time.parse(issue[:closed_at])),
    }

    push_issue(issue[:state], pusher_params)
    render text: params.to_s
  end
end
