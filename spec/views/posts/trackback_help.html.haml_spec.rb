require File.join(File.dirname(__FILE__), "../..", 'spec_helper.rb')

describe "posts/trackback_help" do 
  before :all do
    Merb::Router.prepare { |r| slice(:BlogSlice, :name_prefix => nil, :path_prefix => nil, :default_routes => false) } if standalone?
  end

  after :all do
    Merb::Router.reset! if standalone?
  end
  
  before :each do                    
    @controller = BlogSlice::Posts.new(fake_request)
    @post = Post.new(:title => 'My First Post', :rendered_content => '<b>This is my first blog post</b>', :slug => 'my-first-post', :published_at => Time.now)
    @post.stub!(:tags).and_return([Tag.build('animal'), Tag.build('technology')])

    @controller.instance_variable_set(:@post, @post) 
    @body = @controller.render(:trackback_help)
  end
  
  it "should display some help" do
    @body.should contain("You can send a trackback")
  end
  
  it "should display a input textfield with the trackback url inside" do
    @body.should have_tag("input", :type => 'text') do |input|
      input.should contain("/posts/my-first-post/trackback")
    end
  end
end