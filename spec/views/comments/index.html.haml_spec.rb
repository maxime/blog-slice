require File.join(File.dirname(__FILE__), "../..", 'spec_helper.rb')

describe "comments/index authorized" do 
  before :all do
    Merb::Router.prepare { |r| slice(:BlogSlice, :name_prefix => nil, :path_prefix => nil, :default_routes => false) } if standalone?
  end

  after :all do
    Merb::Router.reset! if standalone?
  end
  
  def sample_comments
    first_comment = Comment.new(:id => 1, :author => "Maxime Guilbot",
                                :url => "http://www.ekohe.com",
                                :rendered_content => 'Very nice blog!')
        
    second_comment = Comment.new(:id => 2, :author => "James Antony",
                                :url => "http://www.ekohe.com",
                                :rendered_content => 'Very beautiful blog!')
    
    [first_comment, second_comment]
  end
  
  before(:each) do                    
    @controller = BlogSlice::Comments.new(fake_request)
    @post = Post.new(:title => "My First Blog Post", :slug => "my-first-blog-post")

    @controller.instance_variable_set(:@post, @post)
    @controller.instance_variable_set(:@comments, sample_comments) 
    @body = @controller.render(:index) 
  end
  
  it "should display the post title" do
    @body.should have_tag(:h1) {|h1| h1.should contain("Comments for")}
    @body.should have_tag(:h1) {|h1| h1.should contain("My First Blog Post")}    
  end
   
  it "should display the comments" do
    @body.should have_tag(:div, :class => 'author') {|div| div.should contain("Maxime Guilbot")}
    @body.should have_tag(:div, :class => 'author') {|div| div.should contain("James Antony")}    
    @body.should have_tag(:div, :class => 'comment') {|div| div.should contain("Very nice blog!")}
    @body.should have_tag(:div, :class => 'comment') {|div| div.should contain("Very beautiful blog!")}    
  end
  
  it "should display edit and delete links" do
    @body.should have_tag(:a, :href => '/posts/my-first-blog-post/comments/1/edit') {|a| a.should contain("Edit")}
    @body.should have_tag(:a, :href => '/posts/my-first-blog-post/comments/2/edit') {|a| a.should contain("Edit")}
                 
    @body.should have_tag(:a, :href => '/posts/my-first-blog-post/comments/1', :method => 'delete') {|a| a.should contain("Delete")}
    @body.should have_tag(:a, :href => '/posts/my-first-blog-post/comments/2', :method => 'delete') {|a| a.should contain("Delete")}
  end
end

describe "comments/index not authorized" do 
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
  
  before(:each) do                    
    @controller = BlogSlice::Comments.new(fake_request)
    @post = mock('post')
    @post.stub!(:class).and_return(Post)
    @post.stub!(:title).and_return("My First Blog Post") 
    @post.stub!(:slug).and_return('my-first-blog-post')
    @controller.stub!(:authorized?).and_return(false)
    @controller.instance_variable_set(:@post, @post)
    @controller.instance_variable_set(:@comments, sample_comments) 
    @body = @controller.render(:index) 
  end
  
  it "should not display edit and delete links" do
    @body.should_not have_tag(:a, :href => '/posts/my-first-blog-post/comments/1/edit') {|a| a.should contain("Edit")}
    @body.should_not have_tag(:a, :href => '/posts/my-first-blog-post/comments/2/edit') {|a| a.should contain("Edit")}

    @body.should_not have_tag(:a, :href => '/posts/my-first-blog-post/comments/1', :method => 'delete') {|a| a.should contain("Delete")}
    @body.should_not have_tag(:a, :href => '/posts/my-first-blog-post/comments/2', :method => 'delete') {|a| a.should contain("Delete")}
  end
end