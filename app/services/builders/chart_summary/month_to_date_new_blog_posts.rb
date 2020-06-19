module Builders
  module ChartSummary
    class MonthToDateNewBlogPosts < BaseService
      def call
        BlogPost
          .where('published_at > ?', Time.zone.now.beginning_of_month)
          .count
      end
    end
  end
end
