class BlogPostCategorizer
  def technology_for(blog_post_payload)
    Technology.all.detect(default_technology) do |technology|
      keywords_for(blog_post_payload).any? do |keyword|
        technology.keywords.include?(keyword)
      end
    end
  end

  def default_technology
    proc { Technology.other }
  end

  def keywords_for(blog_post_payload)
    blog_post_payload[:tags].merge(blog_post_payload[:categories]).keys.map(&:to_s).map(&:downcase)
  end
end
