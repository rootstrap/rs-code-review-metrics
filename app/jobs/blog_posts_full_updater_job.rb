class BlogPostsFullUpdaterJob < ApplicationJob
  queue_as :default

  def perform
    Processors::BlogPostsFullUpdater.call
  end
end
