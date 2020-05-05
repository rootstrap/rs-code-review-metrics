class BlogPostsUpdaterJob < ApplicationJob
  queue_as :default

  def perform
    Processors::BlogPostsUpdater.new.call
  end
end
