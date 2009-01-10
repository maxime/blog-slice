require File.join(File.dirname(__FILE__), "../..", 'spec_helper.rb')

describe "comments/feed" do 
  before :all do
    Merb::Router.prepare { |r| slice(:BlogSlice, :name_prefix => nil, :path_prefix => nil, :default_routes => false) } if standalone?
  end

  after :all do
    Merb::Router.reset! if standalone?
  end
  
  before(:each) do                    
    @controller = BlogSlice::Comments.new(fake_request) 

    post = Post.new(:title => "My First Blog Post", :slug => 'my-first-blog-post', :content => "Bla bla", :created_at => Time.now)

    first_comment = Comment.new(:id => 1, :author => "Maxime", :email => "your@email.com", :content => "Fantastic", :created_at => Time.now)
    
    second_comment = Comment.new(:id => 2, :author => "Another Guy", :email => "your@email.com", :content => "Cool", :created_at => Time.now)

    @controller.instance_variable_set(:@post, post) 
    @controller.instance_variable_set(:@comments, [first_comment, second_comment]) 

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
