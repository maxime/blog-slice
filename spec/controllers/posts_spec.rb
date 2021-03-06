require File.dirname(__FILE__) + '/../spec_helper'

describe "BlogSlice::Posts (controller)" do
  
  # Feel free to remove the specs below
  
  before :all do
    Merb::Router.prepare { |r| add_slice(:BlogSlice, :controller_prefix => nil, :name_prefix => nil, :path_prefix => nil, :default_routes => false) } if standalone?
  end
  
  after :all do
    Merb::Router.reset! if standalone?
  end
  
  it "should have routes in BlogSlice.routes" do
    BlogSlice.named_routes.should_not be_empty
  end
  
  it "should have helper methods for dealing with public paths" do
    Post.all.destroy!
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
  before :all do
    Merb::Router.prepare { |r| slice(:BlogSlice, :name_prefix => nil, :path_prefix => nil, :default_routes => false) } if standalone?
  end
  
  after :all do
    Merb::Router.reset! if standalone?
  end
  
  before :each do
    @post = mock('post')
    Post.stub!(:paginate).and_return([@post])
  end
  
  def do_get
    dispatch_to(BlogSlice::Posts, :index) do |controller|
      controller.stub!(:display)
      yield controller if block_given?
    end
  end
  
  it "should have a route from /posts" do 
    request_to("/posts", :get).should route_to("BlogSlice/posts", :index)   
  end
  
  it "should get all the posts from the database" do
    # TODO: fix this to test the :published_at.lt => Time.now
    # Right now, there is a bug in the Hash class or in Datamapper: {:published_at.lt => 0} != {:published_at.lt => 0}
    # 
    Post.should_receive(:paginate).with(hash_including(:status => 0, :order => [:published_at.desc], :page => nil)).and_return([@post])
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
  before :all do
    Merb::Router.prepare { |r| slice(:BlogSlice, :name_prefix => nil, :path_prefix => nil, :default_routes => false) } if standalone?
  end
  
  after :all do
    Merb::Router.reset! if standalone?
  end

  before :each do
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
    request_to("/posts/new", :get).should route_to('BlogSlice/posts', :new)     
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
    Merb::Router.prepare { |r| slice(:BlogSlice, :name_prefix => nil, :path_prefix => nil, :default_routes => false) } if standalone?
  end
  
  after :all do
    Merb::Router.reset! if standalone?
  end
  
  before do
    @post = Post.new(:slug => 'my-first-blog-post')
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
    request_to("/posts", :post).should route_to('BlogSlice/posts', :create)     
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
    successful_save.should redirect_to('/posts/my-first-blog-post')
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
  before :all do
    Merb::Router.prepare { |r| slice(:BlogSlice, :name_prefix => nil, :path_prefix => nil, :default_routes => false) } if standalone?
  end
  
  after :all do
    Merb::Router.reset! if standalone?
  end
  
  before :each do
    @post = mock('post')
    @post.stub!(:title).and_return("My First Blog Post")
    @post.stub!(:views_count).and_return(0)
    @post.stub!(:update_attributes)
    @post.stub!(:published_at).and_return(2.days.ago)
    Post.stub!(:first).and_return(@post)
    
    @comments = mock('comments')
    @post.stub!(:comments).and_return(@comments)
    
    @new_comment = mock('new-comment')
    Comment.stub!(:new).and_return(@new_comment)
    
    @linkbacks = mock('linkbacks')
    @post.stub!(:linkbacks).and_return(@linkbacks)
    @linkbacks.stub!(:all).and_return([])
  end
  
  def do_get
    dispatch_to(BlogSlice::Posts, :show, :slug => 'my-first-blog-post') do |controller|
      controller.stub!(:display)
      yield controller if block_given?
    end
  end
  
  it "should have a route from /posts/:slug" do
    request_to("/posts/my-first-blog-post", :get).should route_to('BlogSlice/posts', :show)  
  end
  
  it "should get the post from the database" do
    Post.should_receive(:first).with(:slug => 'my-first-blog-post').and_return(@post)
    do_get
  end
  
  it "should assign the post to the view" do
    do_get.assigns(:post).should == @post
  end
  
  it "should raise NotFound if the post isn't found" do
    Post.should_receive(:first).with(:slug => 'my-first-blog-post').and_return(nil)
    lambda { do_get }.should raise_error(Merb::ControllerExceptions::NotFound)
  end
  
  it "should raise NotFound if the post published at is in the future" do
    @post.stub!(:published_at).and_return(Time.now + 2.days)
    lambda { do_get }.should raise_error(Merb::ControllerExceptions::NotFound)    
  end
  
  it "should raise NotFound if the post is a draft and if not authorized" do
    @post.stub!(:status).and_return(1)
    lambda do
      do_get do |controller|
        controller.stub!(:authorized?).and_return(false)
      end
    end.should raise_error(Merb::ControllerExceptions::NotFound)    
  end
  
  it "should not raise NotFound if the post is a draft and if authorized" do
    @post.stub!(:status).and_return(1)
    lambda do
      do_get do |controller|
        controller.stub!(:authorized?).and_return(true)
      end
    end.should_not raise_error(Merb::ControllerExceptions::NotFound)    
  end
  it "should display the post" do
    do_get do |controller|
      controller.should_receive(:display).with(@post)
    end
  end
  
  it "should get the comments of the post" do
    @post.should_receive(:comments).once.and_return(@comments)
    do_get
  end
  
  it "should get the approved linkbacks of the post" do
    @post.should_receive(:linkbacks).once.and_return(@linkbacks)
    @linkbacks.should_receive(:all).with(:approved => true, :order => [:created_at.desc]).and_return([])
    do_get
  end
  
  it "should assign the comments to the view" do
    do_get.assigns(:comments).should == @comments
  end
  
  it "should create a new comment object for the new comment form" do
    Comment.should_receive(:new).with(no_args).and_return(@new_comment)
    do_get
  end
  
  it "should increment the views count" do
    @post.should_receive(:update_attributes).with(:views_count => 1)
    do_get
  end
end

describe Post, 'edit action authorized' do
  before :all do
    Merb::Router.prepare { |r| slice(:BlogSlice, :name_prefix => nil, :path_prefix => nil, :default_routes => false) } if standalone?
  end
  
  after :all do
    Merb::Router.reset! if standalone?
  end
  
  before :each do
    @post = mock('post')
    @post.stub!(:title).and_return("My First Blog Post")
    Post.stub!(:first).and_return(@post)
  end
  
  def do_get
    dispatch_to(BlogSlice::Posts, :edit, :slug => 'my-first-blog-post') do |controller|
      controller.stub!(:render)
      yield controller if block_given?
    end
  end
  
  it "should have a route from /posts/:slug/edit" do
    request_to("/posts/my-first-blog-post/edit", :get).should route_to('BlogSlice/posts', :edit)  
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
    Merb::Router.prepare { |r| slice(:BlogSlice, :name_prefix => nil, :path_prefix => nil, :default_routes => false) } if standalone?
  end
  
  after :all do
    Merb::Router.reset! if standalone?
  end
  
  before(:each) do
    @post = Post.new(:slug => 'my-first-blog-post', :title => "My First Blog Post")
    @post.stub!(:dirty?).and_return(true)
    Post.stub!(:first).and_return(@post)
  end
  
  def attributes
    {"title" => "My First Blog Post", "content" => "Hi all!"}
  end
  
  def successful_save
    @post.stub!(:update_attributes).and_return(true)
    dispatch_to(BlogSlice::Posts, :update, {:slug => 'my-first-blog-post', :post => attributes}) do |controller|
      yield controller if block_given?
    end
  end
  
  def unsuccessful_save
    @post.stub!(:update_attributes).and_return(false)
    dispatch_to(BlogSlice::Posts, :update, {:slug => 'my-first-blog-post', :post => attributes}) do |controller|
      controller.stub!(:render)
      yield controller if block_given?
    end
  end
  
  it "should have a route from /posts/my-first-post PUT" do
    request_to('/posts/my-first-post', :put).should route_to('BlogSlice/posts', :update)
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
    successful_save.should redirect_to('/posts/my-first-blog-post')
  end
  
  it "should redirect to the post if nothing has changed" do
    @post.should_receive(:dirty?).and_return(false)
    unsuccessful_save.should redirect_to('/posts/my-first-blog-post')
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
    Merb::Router.prepare { |r| slice(:BlogSlice, :name_prefix => nil, :path_prefix => nil, :default_routes => false) } if standalone?
  end
  
  after :all do
    Merb::Router.reset! if standalone?
  end
  
  before(:each) do
    @post = mock('post')
    @post.stub!(:title).and_return("My First Blog Post")
    @post.stub!(:destroy)
    Post.stub!(:first).and_return(@post)
  end
  
  def do_destroy
    dispatch_to(BlogSlice::Posts, :destroy, :slug => 'my-first-blog-post')
  end
  
  it "should have a route from /posts/my-first-post DELETE" do
    request_to('/posts/my-first-post', :delete).should route_to('BlogSlice/posts', :destroy)
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
    do_destroy.should redirect_to('/posts')
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

describe BlogSlice::Posts, 'feed' do
  before :all do
    Merb::Router.prepare { |r| slice(:BlogSlice, :name_prefix => nil, :path_prefix => nil, :default_routes => false) } if standalone?
  end
  
  after :all do
    Merb::Router.reset! if standalone?
  end
  
  before :each do
    @post = mock('post')
    Post.stub!(:all).and_return([@post])
  end
  
  def do_get
    dispatch_to(BlogSlice::Posts, :feed) do |controller|
      controller.stub!(:authorized?).and_return(false)
      controller.stub!(:render)
      yield controller if block_given?
    end
  end
  
  it "should have a route from /feed" do
    request_to('/feed', :get).should route_to('BlogSlice/posts', :feed)
  end
  
  it "should get the 10 last posts from the database" do
    Post.should_receive(:all).with(hash_including(:limit => 10, :order => [:created_at.desc])).and_return([@post])
    do_get
  end
  
  it "should assign the posts list to the view" do
    do_get.assigns(:posts).should == [@post]
  end
  
  it "should render the feed xml" do
    do_get do |controller|
      controller.should_receive(:render).with(:layout => false)
    end
  end  
end

describe BlogSlice::Posts, 'trackback' do
  before :all do
    Merb::Router.prepare { |r| slice(:BlogSlice, :name_prefix => nil, :path_prefix => nil, :default_routes => false) } if standalone?
  end
  
  after :all do
    Merb::Router.reset! if standalone?
  end
  
  before :each do
    @post = mock('post')
    @post.stub!(:title).and_return("my blog post")
    @post.stub!(:id).and_return(1)
    Post.stub!(:first).and_return(@post)
    
    @linkback = mock('linkback')
    Linkback.stub!(:new).and_return(@linkback)
    @linkback.stub!(:save).and_return(true)
  end
  
  def do_get
    dispatch_to(BlogSlice::Posts, :trackback, :slug => 'my-blog-post', :method => 'get') do |controller|
      controller.stub!(:authorized?).and_return(false)
      controller.stub!(:render)
      yield controller if block_given?
    end
  end
  
  def do_post
    dispatch_to(BlogSlice::Posts, :trackback, {:slug => 'my-blog-post',
                                              :url => 'http://www.ekohe.com'},
                                              {:request_method => 'post'}) do |controller|
      controller.stub!(:authorized?).and_return(false)
      controller.stub!(:render)
      yield controller if block_given?
    end
  end
  
  it "should have a route from /posts/my-blog-post/trackback GET" do
    request_to('/posts/my-blog-post/trackback', :get).should route_to('BlogSlice/posts', :trackback)
    request_to('/posts/my-blog-post/trackback', :post).should route_to('BlogSlice/posts', :trackback)
  end
  
  it "should get the post from the database" do
    Post.should_receive(:first).with(:slug => 'my-blog-post').and_return(@post)
    do_get
  end
  
  it "should render the template if the request is a GET and not try to create a linkback" do
    Linkback.should_not_receive(:new)
    
    do_get do |controller|
      controller.should_receive(:render).with(:trackback_help)
    end
  end
  
  it "should create a linkback of type trackback" do
    Linkback.should_receive(:new).with(:post_id => 1, :type => 'trackback', :source_url => 'http://www.ekohe.com', :direction => true)
    do_post
  end
  
  it "should try to save the linkback" do
    @linkback.should_receive(:save).and_return(true)
    do_post
  end
  
  it "should render the success template if successful" do
    @linkback.stub!(:save).and_return(true)
    do_post do |controller|
      controller.should_receive(:render).with(:trackback_success, {:layout=>false, :format=>:xml})
    end
  end
  
  it "should render the success failure if successful" do
    @linkback.stub!(:save).and_return(false)
    do_post do |controller|
      controller.should_receive(:render).with(:trackback_failure, {:layout=>false, :format=>:xml})
    end
  end
end