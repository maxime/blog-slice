require File.dirname(__FILE__) + '/../spec_helper'

describe BlogSlice::Comments, "index action" do
  before :all do
    Merb::Router.prepare { |r| r.add_slice(:BlogSlice) } if standalone?
  end
  
  after :all do
    Merb::Router.reset! if standalone?
  end
  
  before :each do
    @post = mock('post')
    @comment = mock('comment')
    Post.stub!(:first).and_return(@post)
    @post.stub!(:comments).and_return([@comment])
  end
  
  def do_get
    dispatch_to(BlogSlice::Comments, :index, :post_id => 'my-first-blog-post') do |controller|
      controller.stub!(:display)
      yield controller if block_given?
    end
  end
  
  it "should have a route from /posts/my-first-blog-post/comments :get" do
    request_to('/blog-slice/posts/my-first-blog-post/comments', :get).should route_to(BlogSlice::Comments, :index)
  end
  
  it "should get the post" do
    Post.should_receive(:first).with(:slug => 'my-first-blog-post').and_return(@post)
    do_get
  end
  
  it "should get all the comments for this blog post" do
    @post.should_receive(:comments).and_return([@comment])
    do_get
  end
  
  it "should assign the comments to the view" do
    do_get.assigns(:comments).should == [@comment]
  end
  
  it "should display the comments" do
    do_get do |controller|
      controller.should_receive(:display).with([@comment])
    end
  end
end

describe BlogSlice::Comments, 'new action' do
  before :all do
    Merb::Router.prepare { |r| r.add_slice(:BlogSlice) } if standalone?
  end
  
  after :all do
    Merb::Router.reset! if standalone?
  end
  
  before :each do
    @post = mock('post')
    @comment = mock('comment')
    Post.stub!(:first).and_return(@post)
    @comments = mock('comments')
    @post.stub!(:comments).and_return(@comments)
    @comments.stub!(:new).and_return(@comment)
  end
  
  def do_get
    dispatch_to(BlogSlice::Comments, :new, :post_id => 'my-first-blog-post') do |controller|
      controller.stub!(:render)
      yield controller if block_given?
    end
  end
  
  it "should have a route from /posts/my-first-blog-post/comments/new GET" do
    request_to('/blog-slice/posts/my-first-blog-post/comments/new', :get).should route_to(BlogSlice::Comments, :new)
  end
  
  it "should get the post" do
    Post.should_receive(:first).with(:slug => 'my-first-blog-post').and_return(@post)
    do_get
  end
  
  it "should create a new comment" do
    @post.should_receive(:comments).and_return(@comments)
    @comments.should_receive(:new).and_return(@comment)
    do_get
  end
  
  it "should assign the new comment to the view" do
    do_get.assigns(:comment).should == @comment
  end
  
  it "should render the form" do
    do_get do |controller|
      controller.should_receive(:render).with(:form)
    end
  end
end


describe BlogSlice::Comments, 'create action' do
  before :all do
    Merb::Router.prepare { |r| r.add_slice(:BlogSlice) } if standalone?
  end
  
  after :all do
    Merb::Router.reset! if standalone?
  end
  
  before :each do
    @post = mock('post')
    @post.stub!(:slug).and_return('my-first-blog-post')
    @comment = mock('comment')
    Post.stub!(:first).and_return(@post)
    @comments = mock('comments')
    @post.stub!(:comments).and_return(@comments)
    @comments.stub!(:new).and_return(@comment)
  end
  
  def attributes
    {"author" => "Maxime Guilbot", "email" => "some@email.com", "url" => "http://www.ekohe.com", "content" => "Nice blog post!"}
  end
  
  def successful_save
    @comment.stub!(:save).and_return(true)
    dispatch_to(BlogSlice::Comments, :create, :comment => attributes, :post_id => 'my-first-blog-post') do |controller|
      yield controller if block_given?
    end
  end
  
  def unsuccessful_save
    @comment.stub!(:save).and_return(false)
    dispatch_to(BlogSlice::Comments, :create, :comment => attributes, :post_id => 'my-first-blog-post') do |controller|
      controller.stub!(:render)
      yield controller if block_given?
    end
  end
  
  it "should have a route from /posts/my-first-blog-post/comments POST" do
    request_to('/blog-slice/posts/my-first-blog-post/comments', :post).should route_to(BlogSlice::Comments, :create)
  end
  
  it "should get the post" do
    Post.should_receive(:first).with(:slug => 'my-first-blog-post').and_return(@post)
    successful_save
  end
  
  it "should create a new comment object" do
    @post.should_receive(:comments).with(no_args).and_return(@comments)
    @comments.should_receive(:new).with(attributes).and_return(@comment)
    successful_save
  end
  
  it "should try to save the comment" do
    @comment.should_receive(:save).with(no_args).and_return(true)
    successful_save
  end
  
  it "should redirect to the comments if successful" do
    successful_save.should redirect_to(url(:blog_slice_post_comments, :post_id => 'my-first-blog-post'))
  end
  
  it "should render the form if unsuccessful" do
    unsuccessful_save do |controller|
      controller.should_receive(:render).with(:form)
    end
  end
end