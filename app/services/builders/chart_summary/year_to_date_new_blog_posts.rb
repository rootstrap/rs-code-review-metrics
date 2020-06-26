module Builders
  module ChartSummary
    class YearToDateNewBlogPosts < BaseService
      def call
        BlogPost
          .where('published_at > ?', Time.zone.now.beginning_of_year)
          .count
      end
    end
  end
end
