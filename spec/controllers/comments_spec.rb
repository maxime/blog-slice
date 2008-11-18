require File.dirname(__FILE__) + '/../spec_helper'

describe BlogSlice::Comments, "index action" do
  before :all do
    Merb::Router.prepare { |r| slice(:BlogSlice, :name_prefix => nil, :path_prefix => nil, :default_routes => false) } if standalone?
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
    request_to('/posts/my-first-blog-post/comments', :get).should route_to('BlogSlice/comments', :index)
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
    Merb::Router.prepare { |r| slice(:BlogSlice, :name_prefix => nil, :path_prefix => nil, :default_routes => false) } if standalone?
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
    request_to('/posts/my-first-blog-post/comments/new', :get).should route_to('BlogSlice/comments', :new)
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
    Merb::Router.prepare { |r| slice(:BlogSlice, :name_prefix => nil, :path_prefix => nil, :default_routes => false) } if standalone?
  end
  
  after :all do
    Merb::Router.reset! if standalone?
  end
  
  before :each do
    @post = Post.new(:slug => 'my-first-blog-post')
    @comment = mock('comment')
    @comment.stub!(:post=).with(@post).and_return(true)
    Post.stub!(:first).and_return(@post)
    Comment.stub!(:new).and_return(@comment)
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
    request_to('/posts/my-first-blog-post/comments', :post).should route_to('BlogSlice/comments', :create)
  end
  
  it "should get the post" do
    Post.should_receive(:first).with(:slug => 'my-first-blog-post').and_return(@post)
    successful_save
  end
  
  it "should create a new comment object" do
    Comment.should_receive(:new).with(attributes).and_return(@comment)
    successful_save
  end
  
  it "should set the comment post" do
    @comment.should_receive(:post=).with(@post)
    successful_save
  end
  
  it "should try to save the comment" do
    @comment.should_receive(:save).with(no_args).and_return(true)
    successful_save
  end
  
  it "should redirect to the comments if successful" do
    successful_save.should redirect_to('/posts/my-first-blog-post')
  end
  
  it "should render the form if unsuccessful" do
    unsuccessful_save do |controller|
      controller.should_receive(:render).with(:form)
    end
  end
end


describe BlogSlice::Comments, 'edit action authorized' do
  before :all do
    Merb::Router.prepare { |r| slice(:BlogSlice, :name_prefix => nil, :path_prefix => nil, :default_routes => false) } if standalone?
  end
  
  after :all do
    Merb::Router.reset! if standalone?
  end
  
  before :each do
    @post = mock('post')
    Post.stub!(:first).and_return(@post)
    @comments = mock('comments')
    @post.stub!(:comments).and_return(@comments)
    @comment = mock('post')
    @comments.stub!(:get).and_return(@comment)
  end
  
  it "should have a route from /posts/my-first-blog-post/comments/1/edit GET" do
    request_to("/posts/my-first-blog-post/comments/1/edit", :get).should route_to('BlogSlice/comments', :edit)
  end
  
  def do_get
    dispatch_to(BlogSlice::Comments, :edit, :post_id => 'my-first-blog-post', :id => "1") do |controller|
      controller.stub!(:authorized).and_return(true)
      controller.stub!(:render)
      yield controller if block_given?
    end
  end
  
  it "should be successful" do
    do_get.should be_successful
  end
  
  it "should get the post from the database" do
    Post.should_receive(:first).with(:slug => 'my-first-blog-post').and_return(@post)
    do_get
  end
  
  it "should assign the post to the view" do
    do_get.assigns(:post).should == @post
  end
  
  it "should raise NotFound if the post isn't found" do
    Post.stub!(:first).and_return(nil)
    lambda { do_get }.should raise_error(Merb::ControllerExceptions::NotFound)
  end
  
  it "should get the comment to edit" do
    @post.should_receive(:comments).and_return(@comments)
    @comments.should_receive(:get).with("1").and_return(@comment)
    do_get
  end
  
  it "should raise NotFound if the comment isn't found" do
    @comments.stub!(:get).and_return(nil)
    lambda { do_get }.should raise_error(Merb::ControllerExceptions::NotFound)
  end
  
  it "should assign the comment to edit to the view" do
    do_get.assigns(:comment).should == @comment
  end
  
  it "should render the form" do
    do_get do |controller|
      controller.should_receive(:render).with(:form)
    end
  end
end


describe BlogSlice::Comments, 'edit action not authorized' do
  it "should raise Unauthorized" do
    lambda do
      dispatch_to(BlogSlice::Comments, :edit) do |controller|
        controller.stub!(:authorized?).and_return(false)
      end
    end.should raise_error(Merb::ControllerExceptions::Unauthorized)
  end
end

describe BlogSlice::Comments, 'update action authorized' do
  before :all do
    Merb::Router.prepare { |r| slice(:BlogSlice, :name_prefix => nil, :path_prefix => nil, :default_routes => false) } if standalone?
  end
  
  after :all do
    Merb::Router.reset! if standalone?
  end
  
  before :each do
    @post = Post.new(:slug => 'my-first-blog-post')
    Post.stub!(:first).and_return(@post)
    @comments = mock('comments')
    @post.stub!(:comments).and_return(@comments)
    @comment = mock('post')
    @comment.stub!(:dirty?).and_return(true)
    @comments.stub!(:get).and_return(@comment)
  end
  
  it "should have a route from /posts/my-first-blog-post/comments/1 PUT" do
    request_to("/posts/my-first-blog-post/comments/1", :put).should route_to('BlogSlice/comments', :update)
  end
  
  def attributes
    {"author" => "Maxime Guilbot", "email" => "some@email.com", "url" => "http://www.ekohe.com", "content" => "Nice blog post!"}
  end
  
  def successful_save
    @comment.stub!(:update_attributes).and_return(true)
    dispatch_to(BlogSlice::Comments, :update, :comment => attributes, :post_id => 'my-first-blog-post', :id => "1") do |controller|
      yield controller if block_given?
    end
  end
  
  def unsuccessful_save
    @comment.stub!(:update_attributes).and_return(false)
    dispatch_to(BlogSlice::Comments, :update, :comment => attributes, :post_id => 'my-first-blog-post', :id => "1") do |controller|
      controller.stub!(:render)
      yield controller if block_given?
    end
  end

  it "should get the post from the database" do
    Post.should_receive(:first).with(:slug => 'my-first-blog-post').and_return(@post)
    successful_save
  end
  
  it "should assign the post to the view" do
    successful_save.assigns(:post).should == @post
  end
  
  it "should raise NotFound if the post isn't found" do
    Post.stub!(:first).and_return(nil)
    lambda { successful_save }.should raise_error(Merb::ControllerExceptions::NotFound)
  end
  
  it "should get the comment to edit" do
    @post.should_receive(:comments).and_return(@comments)
    @comments.should_receive(:get).with("1").and_return(@comment)
    successful_save
  end
  
  it "should assign the comment to the view" do
    successful_save.assigns(:comment).should == @comment
  end
  
  it "should try to update the attributes" do
    @comment.should_receive(:update_attributes).with(attributes).and_return(true)
    @comment.should_not_receive(:dirty?)
    successful_save
  end

  it "should check if comment is dirty if update_attributes return false" do
    @comment.should_receive(:update_attributes).with(attributes).and_return(false)
    @comment.should_receive(:dirty?).and_return(false)
    successful_save
  end
  
  it "should redirect to the blog post if successful" do
    successful_save.should redirect_to('/posts/my-first-blog-post')
  end
  
  it "should render the form if unsuccessful" do
    unsuccessful_save do |controller|
      controller.should_receive(:render).with(:form)
    end
  end
end

describe BlogSlice::Comments, 'update action not authorized' do
  it "should raise Unauthorized" do
    lambda do
      dispatch_to(BlogSlice::Comments, :update) do |controller|
        controller.stub!(:authorized?).and_return(false)
      end
    end.should raise_error(Merb::ControllerExceptions::Unauthorized)
  end
end

describe BlogSlice::Comments, 'delete action authorized' do
  before :all do
    Merb::Router.prepare { |r| slice(:BlogSlice, :name_prefix => nil, :path_prefix => nil, :default_routes => false) } if standalone?
  end
  
  after :all do
    Merb::Router.reset! if standalone?
  end
  
  before :each do
    @post = Post.new(:slug => 'my-first-blog-post')
    Post.stub!(:first).and_return(@post)
    @comments = mock('comments')
    @post.stub!(:comments).and_return(@comments)
    @comment = mock('post')
    @comments.stub!(:get).and_return(@comment)
    @comment.stub!(:destroy).and_return(true)
  end
  
  it "should have a route from /posts/my-first-blog-post/comments/1 DELETE" do
    request_to("/posts/my-first-blog-post/comments/1", :delete).should route_to('BlogSlice/comments', :destroy)
  end
  
  def do_delete
    dispatch_to(BlogSlice::Comments, :destroy, :post_id => 'my-first-blog-post', :id => "1") do |controller|
      yield controller if block_given?
    end
  end
  
  it "should get the post from the database" do
    Post.should_receive(:first).with(:slug => 'my-first-blog-post').and_return(@post)
    do_delete
  end
  
  it "should raise NotFound if the post isn't found" do
    Post.stub!(:first).and_return(nil)
    lambda { do_delete }.should raise_error(Merb::ControllerExceptions::NotFound)
  end
  
  it "should get the comment to delete" do
    @post.should_receive(:comments).and_return(@comments)
    @comments.should_receive(:get).with("1").and_return(@comment)
    do_delete
  end
  
  it "should raise NotFound if the comment isn't found" do
    @comments.stub!(:get).and_return(nil)
    lambda { do_delete }.should raise_error(Merb::ControllerExceptions::NotFound)
  end
  
  it "should delete the comment" do
    @comment.should_receive(:destroy)
    do_delete
  end
  
  it "should redirect to the blog post" do
    do_delete.should redirect_to('/posts/my-first-blog-post')
  end
end

describe BlogSlice::Comments, 'delete action not authorized' do
  it "should raise Unauthorized" do
    lambda do
      dispatch_to(BlogSlice::Comments, :destroy) do |controller|
        controller.stub!(:authorized?).and_return(false)
      end
    end.should raise_error(Merb::ControllerExceptions::Unauthorized)
  end
end