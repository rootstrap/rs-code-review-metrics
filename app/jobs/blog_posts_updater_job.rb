class BlogPostsUpdaterJob < ApplicationJob
  queue_as :default

  def perform(full_update = false)
    Processors::BlogPostsUpdater.call(full_update: full_update)
  end
end
