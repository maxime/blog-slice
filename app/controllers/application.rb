class BlogSlice::Application < Merb::Controller
  include Merb::Helpers::SimpleFormsHelpers
  include Merb::Helpers::LinkHelper
    
  controller_for_slice
  
  def blog_options
    {
      :blog_title => "My Blog",
      :feed_number_of_items => 10,
      :feed_title => "Blog Slice News",
      :feed_link => "http://www.blogslice.com",
      :feed_description => "A Blog about Blog Slice",
      :host => "http://www.example.org",
      :feed_url => "/blog-slice/feed",
      :feed_language => "en-us"
    }
  end
  
  def authorization_required
    raise Unauthorized unless authorized?
  end
  
  def authorized?
    true
  end
end