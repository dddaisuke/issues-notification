class CacheClearsController < ApplicationController
  def show
    Rails.cache.clear
    render text: 'cache clear!'
  end
end
