class TopController < ApplicationController
  def show
    @client = Octokit::Client.new(access_token: session[:github_token])
    issues = @client.list_issues("manabo-inc/manabo", state: 'closed', sort: 'updated')
    @issues = []
    issues.each do |issue|
      next if issue[:pull_request]
      assignee = issue[:assignee]
      if assignee
        sender_name = assignee[:login]
        sender_avatar_url = assignee[:avatar_url]
      else
        sender_name = issue[:user][:login]
        sender_avatar_url = issue[:user][:avatar_url]
      end

      closed_by = Rails.cache.fetch("issue_#{issue[:number]}") do
        result = @client.issue('manabo-inc/manabo', issue[:number])
        {
          sender_name: result[:closed_by][:login],
          sender_avatar_url: result[:closed_by][:avatar_url],
        }
      end

      issue = {
        state: issue[:state],
        number: issue[:number],
        sender_name: closed_by[:sender_name],
        sender_avatar_url: closed_by[:sender_avatar_url],
        title: issue[:title],
        url: issue[:html_url],
        owner_name: issue[:user][:login],
        closed_at: issue[:closed_at],
      }
      @issues << issue
    end
  end
end
