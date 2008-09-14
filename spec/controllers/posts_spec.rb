require File.dirname(__FILE__) + '/../spec_helper'

describe "BlogSlice::Posts (controller)" do
  
  # Feel free to remove the specs below
  
  before :all do
    Merb::Router.prepare { |r| r.add_slice(:BlogSlice) } if standalone?
  end
  
  after :all do
    Merb::Router.reset! if standalone?
  end
  
  it "should have access to the slice module" do
    controller = dispatch_to(BlogSlice::Posts, :index)
    controller.slice.should == BlogSlice
    controller.slice.should == BlogSlice::Posts.slice
  end
  
  it "should have an index action" do
    controller = dispatch_to(BlogSlice::Posts, :index)
    controller.status.should == 200
  end
  
  it "should work with the default route" do
    controller = get("/blog-slice/posts/index")
    controller.should be_kind_of(BlogSlice::Posts)
    controller.action_name.should == 'index'
  end
  
  it "should work with the example named route" do
    controller = get("/blog-slice/posts")
    controller.should be_kind_of(BlogSlice::Posts)
    controller.action_name.should == 'index'
  end
  
  it "should have routes in BlogSlice.routes" do
    BlogSlice.routes.should_not be_empty
  end
  
  it "should have a slice_url helper method for slice-specific routes" do
    controller = dispatch_to(BlogSlice::Posts, 'index')
    controller.slice_url(:action => 'show', :format => 'html').should == "/blog-slice/posts/show.html"
    controller.slice_url(:blog_slice_posts).should == "/blog-slice/posts"
  end
  
  it "should have helper methods for dealing with public paths" do
    controller = dispatch_to(BlogSlice::Posts, :index)
    controller.public_path_for(:image).should == "/slices/blog-slice/images"
    controller.public_path_for(:javascript).should == "/slices/blog-slice/javascripts"
    controller.public_path_for(:stylesheet).should == "/slices/blog-slice/stylesheets"
  end
  
  it "should have a slice-specific _template_root" do
    BlogSlice::Posts._template_root.should == BlogSlice.dir_for(:view)
    BlogSlice::Posts._template_root.should == BlogSlice::Application._template_root
  end
end


describe BlogSlice::Posts, 'index action' do
  before do
    @post = mock('post')
    Post.stub!(:all).and_return([@post])
  end
  
  def do_get
    dispatch_to(BlogSlice::Posts, :index) do |controller|
      controller.stub!(:display)
      yield controller if block_given?
    end
  end
  
  it "should have a route from /posts/index" do 
    request_to("/blog-slice/posts/index", :get).should route_to(BlogSlice::Posts, :index)   
  end
  
  it "should get all the posts from the database" do
    Post.should_receive(:all).with(no_args).and_return([@post])
    do_get
  end
  
  it "should assign the posts list to the view" do
    do_get.assigns(:posts).should == [@post]
  end
  
  it "should call display the posts" do
    do_get do |controller|
      controller.should_receive(:display).with([@post])
    end
  end
end

describe BlogSlice::Posts, 'new action authorized' do
  before do
    @post = mock('post')
    Post.stub!(:new).and_return(@post)
  end
  
  def do_get
    dispatch_to(BlogSlice::Posts, :new) do |controller|
      controller.stub!(:render)
      yield controller if block_given?
    end
  end
  
  it "should have a route from /posts/new" do
    request_to("/blog-slice/posts/new", :get).should route_to(BlogSlice::Posts, :new)     
  end
  
  it "should create a new post object" do
    Post.should_receive(:new).and_return(@post)
    do_get
  end
  
  it "should assign the new created post to the view" do
    do_get.assigns(:post).should == @post
  end
  
  it "should render the form" do
    do_get do |controller|
      controller.should_receive(:render).with(:form)
    end
  end
end

describe BlogSlice::Posts, 'new action not authorized' do
  it "should raise Unauthorized" do
    lambda do
      dispatch_to(BlogSlice::Posts, :new) do |controller|
        controller.stub!(:authorized?).and_return(false)
        controller.stub!(:render)
      end
    end.should raise_error(Merb::ControllerExceptions::Unauthorized)
  end
end

describe BlogSlice::Posts, 'create action' do
  before :all do
    Merb::Router.prepare { |r| r.add_slice(:BlogSlice) } if standalone?
  end
  
  after :all do
    Merb::Router.reset! if standalone?
  end
  
  before do
    @post = mock('post')
    @post.stub!(:slug).and_return('my-first-blog-post')
    Post.stub!(:new).and_return(@post)
  end
  
  def attributes
    {"title" => "My First Blog Post", "content" => "Hi all!"}
  end
  
  def successful_save
    @post.stub!(:save).and_return(true)
    dispatch_to(BlogSlice::Posts, :create, :post => attributes) do |controller|
      yield controller if block_given?
    end
  end
  
  def unsuccessful_save
    @post.stub!(:save).and_return(false)
    dispatch_to(BlogSlice::Posts, :create, :post => attributes) do |controller|
      controller.stub!(:render)
      yield controller if block_given?
    end
  end

  it "should have a route from /posts POST" do
    request_to("/blog-slice/posts", :post).should route_to(BlogSlice::Posts, :create)     
  end
  
  it "should create a new post object" do
    Post.should_receive(:new).with(attributes).and_return(@post)
    successful_save
  end
  
  it "should try to save it" do
    @post.should_receive(:save).and_return(true)
    successful_save
  end
  
  it "should redirect to the post if successful" do
    successful_save.should redirect_to(url(:blog_slice_post, :id => @post.slug))
  end
  
  it "should render the form again if unsuccesful" do
    unsuccessful_save do |controller|
      controller.should_receive(:render).with(:form)
    end
  end
end

describe BlogSlice::Posts, 'create action not authorized' do
  it "should raise Unauthorized" do
    lambda do
      dispatch_to(BlogSlice::Posts, :create) do |controller|
        controller.stub!(:authorized?).and_return(false)
        controller.stub!(:render)
      end
    end.should raise_error(Merb::ControllerExceptions::Unauthorized)
  end
end

describe Post, 'show action' do
  before do
    @post = mock('post')
    Post.stub!(:first).and_return(@post)
  end
  
  def do_get
    dispatch_to(BlogSlice::Posts, :show, :id => 'my-first-blog-post') do |controller|
      controller.stub!(:display)
      yield controller if block_given?
    end
  end
  
  it "should have a route from /posts/:slug" do
    request_to("/blog-slice/posts/my-first-blog-post", :get).should route_to(BlogSlice::Posts, :show)  
  end
  
  it "should get the post from the database" do
    Post.should_receive(:first).with(:slug => 'my-first-blog-post').and_return(@post)
    do_get
  end
  
  it "should raise NotFound if the post isn't found" do
    Post.should_receive(:first).with(:slug => 'my-first-blog-post').and_return(nil)
    lambda { do_get }.should raise_error(Merb::ControllerExceptions::NotFound)
  end
  
  it "should display the post" do
    do_get do |controller|
      controller.should_receive(:display).with(@post)
    end
  end
end

describe Post, 'edit action authorized' do
  before do
    @post = mock('post')
    Post.stub!(:first).and_return(@post)
  end
  
  def do_get
    dispatch_to(BlogSlice::Posts, :edit, :id => 'my-first-blog-post') do |controller|
      controller.stub!(:render)
      yield controller if block_given?
    end
  end
  
  it "should have a route from /posts/:slug/edit" do
    request_to("/blog-slice/posts/my-first-blog-post/edit", :get).should route_to(BlogSlice::Posts, :edit)  
  end  
  
  it "should get the post from the database" do
    Post.should_receive(:first).with(:slug => 'my-first-blog-post').and_return(@post)
    do_get
  end
  
  it "should assign the post to the view" do
    do_get.assigns(:post).should == @post
  end
  
  it "should raise NotFound if the post is not found" do
    Post.stub!(:first).and_return(nil)    
    lambda { do_get }.should raise_error(Merb::ControllerExceptions::NotFound)
  end
  
  it "should render the form" do
    do_get do |controller|
      controller.should_receive(:render).with(:form)
    end
  end
end

describe BlogSlice::Posts, 'edit action not authorized' do
  it "should raise Unauthorized" do
    lambda do
      dispatch_to(BlogSlice::Posts, :edit) do |controller|
        controller.stub!(:authorized?).and_return(false)
      end
    end.should raise_error(Merb::ControllerExceptions::Unauthorized)
  end
end

describe BlogSlice::Posts, 'update action authorized' do
  before :all do
    Merb::Router.prepare { |r| r.add_slice(:BlogSlice) } if standalone?
  end
  
  after :all do
    Merb::Router.reset! if standalone?
  end
  
  before(:each) do
    @post = mock('post')
    @post.stub!(:slug).and_return('my-first-blog-post')
    Post.stub!(:first).and_return(@post)
  end
  
  def attributes
    {"title" => "My First Blog Post", "content" => "Hi all!"}
  end
  
  def successful_save
    @post.stub!(:update_attributes).and_return(true)
    dispatch_to(BlogSlice::Posts, :update, {:id => 'my-first-blog-post', :post => attributes}) do |controller|
      yield controller if block_given?
    end
  end
  
  def unsuccessful_save
    @post.stub!(:update_attributes).and_return(false)
    dispatch_to(BlogSlice::Posts, :update, {:id => 'my-first-blog-post', :post => attributes}) do |controller|
      controller.stub!(:render)
      yield controller if block_given?
    end
  end
  
  it "should have a route from /posts/my-first-post PUT" do
    request_to('/blog-slice/posts/my-first-post', :put).should route_to(BlogSlice::Posts, :update)
  end
  
  it "should get the post from the database" do
    Post.should_receive(:first).with(:slug => 'my-first-blog-post').and_return(@post)
    successful_save
  end
  
  it "should raise NotFound if post isn't found" do
    Post.stub!(:first).and_return(nil)
    lambda { successful_save }.should raise_error(Merb::ControllerExceptions::NotFound)
  end
  
  it "should attempt to update the attributes" do
    @post.should_receive(:update_attributes).and_return(true)
    successful_save
  end
  
  it "should redirect to the post if the update is successful" do
    successful_save.should redirect_to(url(:blog_slice_post, :id => @post.slug))
  end
  
  it "should render the form if the update failed" do
    unsuccessful_save do |controller|
      controller.should_receive(:render).with(:form)
    end
  end
end

describe BlogSlice::Posts, 'update action not authorized' do
  it "should raise Unauthorized" do
    lambda do
      dispatch_to(BlogSlice::Posts, :update) do |controller|
        controller.stub!(:authorized?).and_return(false)
      end
    end.should raise_error(Merb::ControllerExceptions::Unauthorized)
  end
end

describe BlogSlice::Posts, 'destroy action authorized' do
  before :all do
    Merb::Router.prepare { |r| r.add_slice(:BlogSlice) } if standalone?
  end
  
  after :all do
    Merb::Router.reset! if standalone?
  end
  
  before(:each) do
    @post = mock('post')
    @post.stub!(:destroy)
    Post.stub!(:first).and_return(@post)
  end
  
  def do_destroy
    dispatch_to(BlogSlice::Posts, :destroy, :id => 'my-first-blog-post')
  end
  
  it "should have a route from /posts/my-first-post DELETE" do
    request_to('/blog-slice/posts/my-first-post', :delete).should route_to(BlogSlice::Posts, :destroy)
  end
  
  it "should get the post from the database" do
    Post.should_receive(:first).with(:slug => 'my-first-blog-post').and_return(@post)
    do_destroy
  end
  
  it "should raise NotFound if post isn't found" do
    Post.stub!(:first).and_return(nil)
    lambda { do_destroy }.should raise_error(Merb::ControllerExceptions::NotFound)
  end
  
  it "should try to destroy the post" do
    @post.should_receive(:destroy)
    do_destroy
  end
  
  it "should redirect to the post listing" do
    do_destroy.should redirect_to(url(:blog_slice_posts))
  end
end

describe BlogSlice::Posts, 'destroy action not authorized' do
  it "should raise Unauthorized" do
    lambda do
      dispatch_to(BlogSlice::Posts, :destroy) do |controller|
        controller.stub!(:authorized?).and_return(false)
      end
    end.should raise_error(Merb::ControllerExceptions::Unauthorized)
  end
end