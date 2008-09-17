require File.join(File.dirname(__FILE__), "../..", 'spec_helper.rb')

describe "posts/show authorized" do 
  before :all do
    Merb::Router.prepare { |r| r.add_slice(:BlogSlice) } if standalone?
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
    post = Post.new(:title => 'My First Post', :rendered_content => '<b>This is my first blog post</b>', :slug => 'my-first-post', :taglist => 'animal, technology')
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
    @body.should have_tag(:div, :id => 'tags') {|div| div.should contain("animal, technology")}
  end
  
  it "should display the edit link" do
    @body.should have_tag(:a, :href => url(:edit_blog_slice_post, :id => 'my-first-post'))
  end
  
  it "should display the delete link" do
    @body.should have_tag(:a, :href => url(:blog_slice_post, :id => 'my-first-post'), :method => 'delete')
  end
  
  it "should display the number of comments" do
    @body.should have_tag(:div, :class => 'comments_number') {|div| div.should contain("2 Comments")}
  end
  
  it "should display the comments" do
    @body.should have_tag(:div, :id => 'comments').with_tag(:div, :id => 'comment_1')
    @body.should have_tag(:div, :id => 'comments').with_tag(:div, :id => 'comment_2')    
  end
  
  it "should display the new comment form" do
    @body.should have_tag(:form, :action => url(:blog_slice_post_comments, :post_id => 'my-first-post'))
  end
end

describe "posts/show not authorized" do 
  before :all do
    Merb::Router.prepare { |r| r.add_slice(:BlogSlice) } if standalone?
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
    post = Post.new(:title => 'My First Post', :rendered_content => '<b>This is my first blog post</b>', :slug => 'my-first-post')
    @controller.instance_variable_set(:@post, post) 
    @controller.instance_variable_set(:@comments, sample_comments) 
    @controller.instance_variable_set(:@comment, Comment.new) 
    @controller.stub!(:authorized?).and_return(false)
    @body = @controller.render(:show)
  end
  
  it "should not display the edit link" do
    @body.should_not have_tag(:a, :href => url(:edit_blog_slice_post, :id => 'my-first-post'))
  end
  
  it "should not display the delete link" do
    @body.should_not have_tag(:a, :href => url(:blog_slice_post, :id => 'my-first-post'), :method => 'delete')
  end
end

