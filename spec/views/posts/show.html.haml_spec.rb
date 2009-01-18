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
                                :rendered_content => "Very nice blog!", :created_at => Time.now)
                                
    second_comment = Comment.new(:id => 2, :author => "James Antony",
                                :url => "http://www.ekohe.com",
                                :rendered_content => "Very beautiful blog!", :created_at => Time.now)
    
    [first_comment, second_comment]
  end
  
  before :each do                    
    @controller = BlogSlice::Posts.new(fake_request)
    @post = Post.new(:title => 'My First Post', :rendered_content => '<b>This is my first blog post</b>', :slug => 'my-first-post', :published_at => Time.now)
    @post.stub!(:tags).and_return([Tag.build('animal'), Tag.build('technology')])
  end
  
  def render
    @controller.instance_variable_set(:@post, @post) 
    @controller.instance_variable_set(:@comments, sample_comments)
    @controller.instance_variable_set(:@comment, Comment.new) 
    @body = @controller.render(:show)
  end
  
  it "should display the blog post title" do
    render
    @body.should have_tag(:h1) {|h1| h1.should contain("My First Post")}
  end
  
  it "should display the blog post rendered content" do
    render
    @body.should have_tag(:div, :id => 'content') {|div| div.should contain("This is my first blog post")}
  end
  
  it "should display the tags" do
    render
    @body.should have_tag(:div, :id => 'tags') do |div|
      div.should contain("animal")
      div.should contain("technology")
    end
  end
  
  it "should display the edit link" do
    render
    @body.should have_tag(:a, :href => '/posts/my-first-post/edit')
  end
  
  it "should display the delete link" do
    render
    @body.should have_tag(:a, :href => '/posts/my-first-post', :method => 'delete')
  end
  
  it "should display the number of comments if enabled" do
    render
    @body.should have_tag(:div, :class => 'comments_number') {|div| div.should contain("2 Comments")}
  end
  
  it "should display the comments if enabled" do
    render
    @body.should have_tag(:div, :id => 'comment_1')
    @body.should have_tag(:div, :id => 'comment_2')    
  end
  
  it "should display the new comment form if enabled" do
    render
    @body.should have_tag(:form, :action => '/posts/my-first-post/comments')
  end
  
  it "should not display the comments if disabled" do
    @post.allow_comments = false
    render
    @body.should_not have_tag(:div, :class => 'comments_number')
  end

  it "should not display the new comment form if disabled" do
    @post.allow_comments = false
    render
    @body.should_not have_tag(:form, :action => '/posts/my-first-post/comments')
  end
  
  it 'should display Draft if the post is a draft' do
    @post.status = 1
    render
    @body.should contain("Draft")
  end

  it 'should display Pending review if the post is pending review' do
    @post.status = 2
    render
    @body.should contain("Pending review")
  end
end

describe "posts/show not authorized" do 
  before :all do
    Merb::Router.prepare { |r| slice(:BlogSlice, :name_prefix => nil, :path_prefix => nil, :default_routes => false) } if standalone?
  end

  after :all do
    Merb::Router.reset! if standalone?
  end
  
  def create_comments
    first_comment = Comment.create(:author => "Maxime Guilbot",
                                   :url => "http://www.ekohe.com",
                                   :content => "Very nice post!",
                                   :approved => true,
                                   :post_id => @post.id,
                                   :created_at => Time.now)
    
    second_comment = Comment.create(:author => "James Antony",
                                    :url => "http://www.ekohe.com",
                                    :content => "F*cking website!!",
                                    :approved => false,
                                    :post_id => @post.id,
                                    :created_at => Time.now)
  end
  
  before :each do                    
    @controller = BlogSlice::Posts.new(fake_request)
    Post.all.destroy!
    Comment.all.destroy!
    @post = Post.create(:title => 'My First Post', :rendered_content => '<b>This is my first blog post</b>', :slug => 'my-first-post', :published_at => Time.now)
    @post.stub!(:tags).and_return([Tag.build('animal'), Tag.build('technology')])
    create_comments
    @controller.instance_variable_set(:@post, @post) 
    @controller.instance_variable_set(:@comments, @post.comments) 
    @controller.instance_variable_set(:@comment, Comment.new) 
    @controller.stub!(:authorized?).and_return(false)
  end
  
  def render
    @body = @controller.render(:show)    
  end
  
  it "should not display the edit link" do
    render
    @body.should_not have_tag(:a, :href => '/post/my-first-post/edit')
  end
  
  it "should not display the delete link" do
    render
    @body.should_not have_tag(:a, :href => '/post/my-first-post', :method => 'delete')
  end
  
  it "should not display not approved comments" do
    render
    @body.should_not have_tag(:div, :id => "comment_2")
    @body.should_not contain("F*cking")
  end
  
  it "should not display the trackback url if not allowed" do
    @post.allow_trackbacks = false
    render
    @body.should_not have_tag(:a, :href => '/posts/my-first-post/trackback')
  end
  
  it "should display the trackback url if allowed" do
    @post.allow_trackbacks = true
    render
    @body.should have_tag(:a, :href => '/posts/my-first-post/trackback')
  end
end

