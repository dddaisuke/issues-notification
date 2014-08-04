class TopController < ApplicationController
  def show
    @client = Octokit::Client.new(access_token: session[:github_token])
    issues_by_closed_at = []
    issues_by_closed_at += load_issue_informations(@client, 'manabo-inc', 'manabo')
    issues_by_closed_at += load_issue_informations(@client, 'manabo-inc', 'mana.bo_android')
    issues_by_closed_at += load_issue_informations(@client, 'manabo-inc', 'mana.bo_iOS')
    issues_by_closed_at.sort! {|a, b| a[:closed_at] <=> b[:closed_at] }.reverse!
    @issues = issues_by_closed_at.map do |issue_by_closed_at|
      issue_by_closed_at[:issue]
    end
  end

  private

  def load_issue_informations(client, organization, repository)
    result_issues = []
    issues = client.list_issues("#{organization}/#{repository}", state: 'closed', sort: 'updated')
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

      closed_by = Rails.cache.fetch("#{repository}#issue_#{issue[:number]}") do
        result = client.issue("#{organization}/#{repository}", issue[:number])
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
        closed_at: I18n.l(issue[:closed_at]),
      }
      result_issues << { closed_at: issue[:closed_at].to_time.to_i, issue: issue }
    end
    result_issues
  end
end
