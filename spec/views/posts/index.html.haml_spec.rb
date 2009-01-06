require File.join(File.dirname(__FILE__), "../..", 'spec_helper.rb')

describe "posts/index authorized" do 
  before :all do
    Merb::Router.prepare { |r| slice(:BlogSlice, :name_prefix => nil, :path_prefix => nil, :default_routes => false) } if standalone?
  end

  after :all do
    Merb::Router.reset! if standalone?
  end
  
  before(:each) do                    
    @controller = BlogSlice::Posts.new(fake_request) 
    first_post = Post.new(:id => 1, :slug => 'my-first-post', :title => "My First Post",
                          :rendered_content => '<b>This is my first post</b>', :published_at => Time.now)
    first_post.stub!(:comments).and_return([])
    first_post.stub!(:tags).and_return([Tag.build('english'), Tag.build('technology')])

    second_post = Post.new(:id => 2, :slug => 'my-second-post', :title => "My Second Post",
                           :rendered_content => '<strong>This is the second post of my blog</strong>', :published_at => Time.now)
    second_post.stub!(:comments).and_return([])
    second_post.stub!(:tags).and_return([Tag.build('love'), Tag.build('food')])
    posts = [first_post, second_post]
    posts.stub!(:total_pages).and_return(1)
    @controller.instance_variable_set(:@posts, posts) 
    @controller.stub!(:authorized?).and_return(true)
    
    @controller.stub!(:blog_options).and_return(:blog_title => "My Own Blog")
    @body = @controller.render(:index) 
  end 
 
  it "should display the title" do
    @body.should have_tag(:h1) {|h1| h1.should contain("My Own Blog")}
  end
 
  it "should display the posts list" do
    @body.should have_tag(:div, :id => 'post_1')
    @body.should have_tag(:div, :id => 'post_2')
  end
 
  it "should display the posts titles" do
    @body.should have_tag(:h1) {|h1| h1.should contain("My First Post")}
    @body.should have_tag(:h1) {|h1| h1.should contain("My Second Post")}
  end

  it "should have links to the post show action" do
    @body.should have_tag(:a, :href => '/posts/my-first-post')
    @body.should have_tag(:a, :href => '/posts/my-second-post')
  end

  it "should display the posts rendered content" do
    @body.should have_tag(:div, :class => "content") {|div| div.should contain("This is my first post")}
    @body.should have_tag(:div, :class => "content") {|div| div.should contain("This is the second post of my blog")}
  end  
 
  it "should display the tags list" do
    @body.should have_tag(:div, :class => 'tags') do |div|
      div.should contain("english")
      div.should contain("technology")
      div.should contain("love")
      div.should contain("food")
    end
  end
 
  it "should have a link for creating a new post if authorized" do
    @body.should have_tag(:a, :href => '/posts/new')
  end
end

describe "posts/index not authorized" do 
  before :all do
    Merb::Router.prepare { |r| slice(:BlogSlice, :name_prefix => nil, :path_prefix => nil, :default_routes => false) } if standalone?
  end

  after :all do
    Merb::Router.reset! if standalone?
  end
  
  before(:each) do                    
    @controller = BlogSlice::Posts.new(fake_request) 
    
    first_post = Post.new(:id => 1, :slug => 'my-first-post', :title => "My First Post",
                          :rendered_content => '<b>This is my first post</b>', :published_at => Time.now)
    first_post.stub!(:comments).and_return([])
    first_post.stub!(:tags).and_return([Tag.build('english'), Tag.build('technology')])

    second_post = Post.new(:id => 2, :slug => 'my-second-post', :title => "My Second Post",
                           :rendered_content => '<strong>This is the second post of my blog</strong>', :published_at => Time.now)
    second_post.stub!(:comments).and_return([])
    second_post.stub!(:tags).and_return([Tag.build('love'), Tag.build('food')])
    posts = [first_post, second_post]
    posts.stub!(:total_pages).and_return(1)
    @controller.instance_variable_set(:@posts, posts) 
    @controller.stub!(:authorized?).and_return(false)
    @body = @controller.render(:index) 
  end 

 
 it "should not have a link for creating a new post if not authorized" do
   @body.should_not have_tag(:a, :href => '/posts/new')  
 end
end