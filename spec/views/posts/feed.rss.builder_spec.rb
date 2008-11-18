require File.join(File.dirname(__FILE__), "../..", 'spec_helper.rb')

describe "posts/feed" do 
  before :all do
    Merb::Router.prepare { |r| slice(:BlogSlice, :name_prefix => nil, :path_prefix => nil, :default_routes => false) } if standalone?
  end

  after :all do
    Merb::Router.reset! if standalone?
  end
  
  before(:each) do                    
    @controller = BlogSlice::Posts.new(fake_request) 
    first_post = mock('first_post')
    first_post.stub!(:id).and_return(1)
    first_post.stub!(:slug).and_return('my-first-post')
    first_post.stub!(:class).and_return(Post)
    first_post.stub!(:title).and_return("My First Post")
    first_post.stub!(:tags_list).and_return("english, technology")
    first_post.stub!(:rendered_content).and_return("<b>This is my first post</b>")
    first_post.stub!(:created_at).and_return(1.day.ago)
    
    second_post = mock('second_post')
    second_post.stub!(:id).and_return(2)
    second_post.stub!(:slug).and_return('my-second-post')
    second_post.stub!(:class).and_return(Post)
    second_post.stub!(:title).and_return("My Second Post")
    second_post.stub!(:tags_list).and_return("love, food")
    second_post.stub!(:rendered_content).and_return("<strong>This is the second post of my blog</strong>")
    second_post.stub!(:created_at).and_return(7.days.ago)
    @controller.instance_variable_set(:@posts, [first_post, second_post]) 
    @body = @controller.render(:feed, :format => :rss, :layout => false) 
  end 
 
  it "should have a rss tag" do
    @body.should have_tag(:rss)
  end
  
  it "should have a channel tag in the rss tag" do
    @body.should have_tag(:channel)
  end
  
  it "should have the required channel elements" do
    @body.should have_tag(:title)
    @body.should have_tag(:link)
    @body.should have_tag(:description)    
  end
  
  it "should have an item with a title and a description" do
    @body.should have_tag(:item)
    @body.should have_tag(:title)
    @body.should have_tag(:description)    
  end
end
