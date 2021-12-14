module PullRequests
  class PullRequestsController < ApplicationController
    layout 'sidebar_metrics'
    include LoadSettings
  end
end
