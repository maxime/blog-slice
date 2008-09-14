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
    controller = get("/blog-slice/index.html")
    controller.should be_kind_of(BlogSlice::Posts)
    controller.action_name.should == 'index'
  end
  
  it "should have routes in BlogSlice.routes" do
    BlogSlice.routes.should_not be_empty
  end
  
  it "should have a slice_url helper method for slice-specific routes" do
    controller = dispatch_to(BlogSlice::Posts, 'index')
    controller.slice_url(:action => 'show', :format => 'html').should == "/blog-slice/posts/show.html"
    controller.slice_url(:blog_slice_index).should == "/blog-slice/"
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

describe BlogSlice::Posts, 'new action' do
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