class BlogSlice::Application < Merb::Controller
  include Merb::Helpers::SimpleFormsHelpers
  controller_for_slice
  
  def feed_options
    {
      :number_of_items => 10,
      :title => "Blog Slice News",
      :link => "http://www.blogslice.com",
      :description => "A Blog about Blog Slice",
      :host => "http://www.example.org",
      :feed_url => "/blog-slice/feed",
      :language => "en-us"
    }
  end
  
  def authorization_required
    raise Unauthorized unless authorized?
  end
  
  def authorized?
    true
  end
end