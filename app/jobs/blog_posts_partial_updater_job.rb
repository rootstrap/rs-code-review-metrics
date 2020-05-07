class BlogPostsPartialUpdaterJob < ApplicationJob
  queue_as :default

  def perform
    Processors::BlogPostsPartialUpdater.call
  end
end
