require File.join(File.dirname(__FILE__), "../..", 'spec_helper.rb')

describe "posts/show authorized" do 
  before :all do
    Merb::Router.prepare { |r| slice(:BlogSlice, :name_prefix => nil, :path_prefix => nil, :default_routes => false) } if standalone?
  end

  after :all do
    Merb::Router.reset! if standalone?
  end
  
  def sample_comments
    first_comment = Comment.new(:id => 1, :author => "Maxime Guilbot",
                                :url => "http://www.ekohe.com",
                                :rendered_content => "Very nice blog!")
                                
    second_comment = Comment.new(:id => 2, :author => "James Antony",
                                :url => "http://www.ekohe.com",
                                :rendered_content => "Very beautiful blog!")
    
    [first_comment, second_comment]
  end
  
  before :each do                    
    @controller = BlogSlice::Posts.new(fake_request)
    post = Post.new(:title => 'My First Post', :rendered_content => '<b>This is my first blog post</b>', :slug => 'my-first-post', :published_at => Time.now)
    post.stub!(:tags).and_return([Tag.build('animal'), Tag.build('technology')])
    
    @controller.instance_variable_set(:@post, post) 
    @controller.instance_variable_set(:@comments, sample_comments)
    @controller.instance_variable_set(:@comment, Comment.new) 
    @body = @controller.render(:show)
  end
  
  it "should display the blog post title" do
    @body.should have_tag(:h1) {|h1| h1.should contain("My First Post")}
  end
  
  it "should display the blog post rendered content" do
    @body.should have_tag(:div, :id => 'content') {|div| div.should contain("This is my first blog post")}
  end
  
  it "should display the tags" do
    @body.should have_tag(:div, :id => 'tags') do |div|
      div.should contain("animal")
      div.should contain("technology")
    end
  end
  
  it "should display the edit link" do
    @body.should have_tag(:a, :href => '/posts/my-first-post/edit')
  end
  
  it "should display the delete link" do
    @body.should have_tag(:a, :href => '/posts/my-first-post', :method => 'delete')
  end
  
  it "should display the number of comments" do
    @body.should have_tag(:div, :class => 'comments_number') {|div| div.should contain("2 Comments")}
  end
  
  it "should display the comments" do
    @body.should have_tag(:div, :id => 'comment_1')
    @body.should have_tag(:div, :id => 'comment_2')    
  end
  
  it "should display the new comment form" do
    @body.should have_tag(:form, :action => '/posts/my-first-post/comments')
  end
end

describe "posts/show not authorized" do 
  before :all do
    Merb::Router.prepare { |r| slice(:BlogSlice, :name_prefix => nil, :path_prefix => nil, :default_routes => false) } if standalone?
  end

  after :all do
    Merb::Router.reset! if standalone?
  end
  
  def sample_comments
    first_comment = mock('first-comment')
    first_comment.stub!(:id).and_return(1)
    first_comment.stub!(:author).and_return("Maxime Guilbot")
    first_comment.stub!(:url).and_return("http://www.ekohe.com")
    first_comment.stub!(:rendered_content).and_return("Very nice blog!")
        
    second_comment = mock('second-comment')
    second_comment.stub!(:id).and_return(2)
    second_comment.stub!(:author).and_return("James Antony")
    second_comment.stub!(:url).and_return("http://www.ekohe.com")
    second_comment.stub!(:rendered_content).and_return("Very beautiful blog!")
    
    [first_comment, second_comment]
  end
  
  before :each do                    
    @controller = BlogSlice::Posts.new(fake_request)
    post = Post.new(:title => 'My First Post', :rendered_content => '<b>This is my first blog post</b>', :slug => 'my-first-post', :published_at => Time.now)
    post.stub!(:tags).and_return([Tag.build('animal'), Tag.build('technology')])
    
    @controller.instance_variable_set(:@post, post) 
    @controller.instance_variable_set(:@comments, sample_comments) 
    @controller.instance_variable_set(:@comment, Comment.new) 
    @controller.stub!(:authorized?).and_return(false)
    @body = @controller.render(:show)
  end
  
  it "should not display the edit link" do
    @body.should_not have_tag(:a, :href => '/post/my-first-post/edit')
  end
  
  it "should not display the delete link" do
    @body.should_not have_tag(:a, :href => '/post/my-first-post', :method => 'delete')
  end
end

