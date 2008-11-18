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
                          :tags_list => 'english, technology',
                          :rendered_content => '<b>This is my first post</b>')
    
    second_post = Post.new(:id => 2, :slug => 'my-second-post', :title => "My Second Post",
                           :tags_list => 'love, food',
                           :rendered_content => '<strong>This is the second post of my blog</strong>')

    @controller.instance_variable_set(:@posts, [first_post, second_post]) 
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
    @body.should have_tag(:h2) {|h2| h2.should contain("My First Post")}
    @body.should have_tag(:h2) {|h2| h2.should contain("My Second Post")}
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
    @body.should have_tag(:div, :class => 'tags') {|div| div.should contain("english, technology") }
    @body.should have_tag(:div, :class => 'tags') {|div| div.should contain("love, food") }
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
    
    first_post = mock('first_post')
    first_post.stub!(:id).and_return(1)
    first_post.stub!(:slug).and_return('my-first-post')
    first_post.stub!(:class).and_return(Post)
    first_post.stub!(:title).and_return("My First Post")
    first_post.stub!(:tags_list).and_return("english, technology")
    first_post.stub!(:rendered_content).and_return("<b>This is my first post</b>")
    
    second_post = mock('second_post')
    second_post.stub!(:id).and_return(2)
    second_post.stub!(:slug).and_return('my-second-post')
    second_post.stub!(:class).and_return(Post)
    second_post.stub!(:title).and_return("My Second Post")
    second_post.stub!(:tags_list).and_return("love, food")
    second_post.stub!(:rendered_content).and_return("<strong>This is the second post of my blog</strong>")
    
    @controller.instance_variable_set(:@posts, [first_post, second_post]) 
    @controller.stub!(:authorized?).and_return(false)
    @body = @controller.render(:index) 
  end 

 
 it "should not have a link for creating a new post if not authorized" do
   @body.should_not have_tag(:a, :href => '/posts/new')  
 end
end