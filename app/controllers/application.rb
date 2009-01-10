class BlogSlice::Application < Merb::Controller
  controller_for_slice
  
  def blog_options
    {
      :blog_title => "My Blog",
      :feed_number_of_items => 10,
      :feed_title => "Blog Slice News",
      :feed_link => "http://www.blogslice.com",
      :feed_description => "A Blog about Blog Slice",
      :host => "http://www.example.org",
      :feed_url => "/feed",
      :feed_language => "en-us",
    }
  end
  
  # This is not used yet
  def comment_options
    {
      :moderate => false, # Enter true if you want to moderate every comments
      :notify_on_creation => false, # Enter an email address if you want to be notified for every comment created
      :notify_on_creation_sender => "yourblog@email.com"
    }
  end
  
  def negative_captcha_secret
    "49f68a5c8495ec2c0bf480821c21fc3b" # please override this 
  end
  
  def authorization_required
    raise Unauthorized unless authorized?
  end
  
  def authorized?
    true
  end
end