class BlogPostsUpdaterJob < ApplicationJob
  queue_as :default

  def perform
    Processors::BlogPostsUpdater.call
  end
end
