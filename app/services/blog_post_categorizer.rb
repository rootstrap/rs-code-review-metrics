class BlogPostCategorizer
  def technologies_for(blog_post_payload)
    matching_technologies = technologies.select do |technology|
      keywords_for(blog_post_payload).any? do |keyword|
        technology.keywords.include?(keyword)
      end
    end

    matching_technologies << default_technology if matching_technologies.empty?

    matching_technologies
  end

  private

  def technologies
    @technologies ||= Technology.all
  end

  def default_technology
    @default_technology ||= Technology.other
  end

  def keywords_for(blog_post_payload)
    blog_post_payload[:tags].merge(blog_post_payload[:categories]).keys.map(&:to_s).map(&:downcase)
  end
end
