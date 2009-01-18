require File.dirname(__FILE__) + '/../spec_helper'

# Non-nested

describe BlogSlice::Linkbacks, "index action" do
  before :all do
    Merb::Router.prepare { |r| slice(:BlogSlice, :name_prefix => nil, :path_prefix => nil, :default_routes => false) } if standalone?
  end
  
  after :all do
    Merb::Router.reset! if standalone?
  end

  before :each do
    @linkbacks = mock('linkbacks')
    Linkback.stub!(:all).and_return(@linkbacks)
  end
  
  def do_index
    dispatch_to(BlogSlice::Linkbacks, :index) do |controller|
      controller.stub!(:display)
      yield controller if block_given?
    end
  end
  
  it "should have a route from /linkbacks GET" do
    request_to('/linkbacks', :get).should route_to("BlogSlice/linkbacks", :index)
  end
  
  it "should be successful" do
    do_index.should be_successful
  end
  
  it "should get the BlogSlice::Linkbacks from the database" do
    Linkback.should_receive(:all).with(no_args).and_return(@linkbacks)
    do_index
  end
  
  it "should render the BlogSlice::Linkbacks" do
    do_index do |controller|
      controller.should_receive(:display).with(@linkbacks)
    end
  end
  
  it "should assign the BlogSlice::Linkbacks to the view" do
    do_index.assigns(:linkbacks).should == @linkbacks
  end
end

describe BlogSlice::Linkbacks, "show action" do
  before :all do
    Merb::Router.prepare { |r| slice(:BlogSlice, :name_prefix => nil, :path_prefix => nil, :default_routes => false) } if standalone?
  end
  
  after :all do
    Merb::Router.reset! if standalone?
  end

  before :each do
    @linkback = mock('linkback')
    Linkback.stub!(:get).and_return(@linkback)
  end
  
  it "should have a route from /linkbacks/1 GET" do
    request_to('/linkbacks/1', :get).should route_to("BlogSlice/linkbacks", :show)
  end
  
  def do_show
    dispatch_to(BlogSlice::Linkbacks, :show, :id => 1) do |controller|
      controller.stub!(:display)
      yield controller if block_given?
    end
  end
  
  it "should be successful" do
    do_show.should be_successful
  end
  
  it "should get the Linkback from the database" do
    Linkback.should_receive(:get).with("1").and_return(@linkback)
    do_show
  end
  
  it "should raise NotFound if the Linkback isn't found" do
    Linkback.stub!(:get).and_return(nil)
    lambda { do_show }.should raise_error(Merb::ControllerExceptions::NotFound)
  end
  
  it "should assigns the Linkback for the view" do
    do_show.assigns(:linkback).should == @linkback
  end
  
  it "should display the linkback" do
    do_show do |controller|
      controller.should_receive(:display).with(@linkback)
    end
  end
end

describe BlogSlice::Linkbacks, "new action" do
  before :all do
    Merb::Router.prepare { |r| slice(:BlogSlice, :name_prefix => nil, :path_prefix => nil, :default_routes => false) } if standalone?
  end
  
  after :all do
    Merb::Router.reset! if standalone?
  end

  before :each do
    @linkback = mock("linkback")
    Linkback.stub!(:new).and_return(@linkback)
  end
  
  it "should have a route from /linkbacks/new GET" do
    request_to("/linkbacks/new", :get).should route_to("BlogSlice/linkbacks", :new)
  end
  
  def do_new
    dispatch_to(BlogSlice::Linkbacks, :new) do |controller|
      controller.stub!(:display)
      yield controller if block_given?
    end
  end
  
  it "should be successful" do
    do_new.should be_successful
  end
  
  it "should create a new Linkback object" do
    Linkback.should_receive(:new).with(no_args).and_return(@linkback)
    do_new
  end
  
  it "should assigns the Linkback object for the view" do
    do_new.assigns(:linkback).should == @linkback
  end
  
  it "should render the Linkback" do
    do_new do |controller|
      controller.should_receive(:display).with(@linkback, :form)
    end
  end
end

describe BlogSlice::Linkbacks, "edit action" do
  before :all do
    Merb::Router.prepare { |r| slice(:BlogSlice, :name_prefix => nil, :path_prefix => nil, :default_routes => false) } if standalone?
  end
  
  after :all do
    Merb::Router.reset! if standalone?
  end

  before :each do
    @linkback = mock("linkback")
    Linkback.stub!(:get).and_return(@linkback)
  end
  
  it "should have a route from /linkbacks/1/edit GET" do
    request_to("/linkbacks/1/edit", :get).should route_to("BlogSlice/linkbacks", :edit)
  end
  
  def do_edit
    dispatch_to(BlogSlice::Linkbacks, :edit, :id => 1) do |controller|
      controller.stub!(:display)
      yield controller if block_given?
    end
  end
  
  it "should be successful" do
    do_edit.should be_successful
  end
  
  it "should get the Linkback object" do
    Linkback.should_receive(:get).with("1").and_return(@linkback)
    do_edit
  end
  
  it "should raise NotFound if the Linkback object isn't found" do
    Linkback.stub!(:get).and_return(nil)
    lambda { do_edit }.should raise_error(Merb::ControllerExceptions::NotFound)
  end
  
  it "should assigns the Linkback object for the view" do
    do_edit.assigns(:linkback).should == @linkback
  end
  
  it "should render the Linkback" do
    do_edit do |controller|
      controller.should_receive(:display).with(@linkback, :form)
    end
  end
end

describe BlogSlice::Linkbacks, 'create action' do
  before :all do
    Merb::Router.prepare { |r| slice(:BlogSlice, :name_prefix => nil, :path_prefix => nil, :default_routes => false) } if standalone?
  end
  
  after :all do
    Merb::Router.reset! if standalone?
  end

  before :each do
    @linkback = Linkback.new
    @linkback.stub!(:save).and_return(true)
    @linkback.stub!(:id).and_return(1)
    
    Linkback.stub!(:new).and_return(@linkback)
  end
  
  it "should have a route from /linkbacks POST" do
    request_to("/linkbacks", :post).should route_to("BlogSlice/linkbacks", :create)
  end
  
  def attributes
    {"name" => "some name"}
  end
  
  def do_create
    dispatch_to(BlogSlice::Linkbacks, :create, :linkback => attributes) do |controller|
      controller.stub!(:display)
      yield controller if block_given?
    end
  end
  
  it "should create a new Linkback object" do
    Linkback.should_receive(:new).with(attributes).and_return(@linkback)
    do_create
  end
  
  it "should try to save the Linkback" do
    @linkback.should_receive(:save).with(no_args)
    do_create
  end
  
  it "should redirect to the newly created Linkback if successful" do
    do_create.should redirect_to(resource(@linkback), :message => {:notice => "Linkback was successfully created"})
  end
  
  it "should render the form if not successful" do
    @linkback.stub!(:save).and_return(false)
    do_create do |controller|
      controller.should_receive(:display).with(@linkback, :form)
    end
  end
  
  it "should assign the Linkback to the view" do
    do_create.assigns(:linkback).should == @linkback
  end
end

describe BlogSlice::Linkbacks, 'update' do
  before :all do
    Merb::Router.prepare { |r| slice(:BlogSlice, :name_prefix => nil, :path_prefix => nil, :default_routes => false) } if standalone?
  end
  
  after :all do
    Merb::Router.reset! if standalone?
  end

  before :each do
    @linkback = Linkback.new(:id => "1")
    Linkback.stub!(:get).and_return(@linkback)
    
    @linkback.stub!(:update_attributes).and_return(true)
  end
  
  it "should have a route from /linkbacks/1 PUT" do
    request_to("/linkbacks/1", :put).should route_to("BlogSlice/linkbacks", :update)
  end
  
  def attributes
    {"name" => "some name"}
  end
  
  def do_update
    dispatch_to(BlogSlice::Linkbacks, :update, :id => 1, :linkback => attributes) do |controller|
      controller.stub!(:display)
      yield controller if block_given?
    end
  end
  
  it "should get the Linkback from the database" do
    Linkback.should_receive(:get).and_return(@linkback)
    do_update
  end
  
  it "should raise NotFound if the Linkback isn't found" do
    Linkback.stub!(:get).and_return(nil)
    lambda { do_update }.should raise_error(Merb::ControllerExceptions::NotFound)
  end
  
  it "should try to save the Linkback" do
    @linkback.should_receive(:update_attributes).with(attributes)
    do_update
  end
  
  it "should redirect to the Linkback if successful" do
    do_update.should redirect_to("/linkbacks/1")
  end
  
  it "should render the form if the Linkback can't be saved" do
    @linkback.stub!(:update_attributes).and_return(false)
    do_update do |controller|
      controller.should_receive(:display).with(@linkback, :form)
    end
  end
  
  it "should assign the Linkback to the view" do
    do_update.assigns(:linkback).should == @linkback
  end
end

describe BlogSlice::Linkbacks, 'destroy' do
  before :all do
    Merb::Router.prepare { |r| slice(:BlogSlice, :name_prefix => nil, :path_prefix => nil, :default_routes => false) } if standalone?
  end
  
  after :all do
    Merb::Router.reset! if standalone?
  end

  before :each do
    @linkback = Linkback.new(:id => "1")
    Linkback.stub!(:get).and_return(@linkback)
    
    @linkback.stub!(:destroy).and_return(true)
  end
  
  it "should have a route from /linkbacks/1 DELETE" do
    request_to("/linkbacks/1", :delete).should route_to("BlogSlice/linkbacks", :destroy)
  end
  
  def do_delete
    dispatch_to(BlogSlice::Linkbacks, :destroy, :id => 1) do |controller|
      yield controller if block_given?
    end
  end
  
  it "should get the Linkback from the database" do
    Linkback.should_receive(:get).and_return(@linkback)
    do_delete
  end
  
  it "should raise NotFound if the Linkback isn't found" do
    Linkback.stub!(:get).and_return(nil)
    lambda { do_delete }.should raise_error(Merb::ControllerExceptions::NotFound)
  end
  
  it "should try to delete the Linkback" do
    @linkback.should_receive(:destroy)
    do_delete
  end
  
  it "should redirect to the BlogSlice::Linkbacks list if destroyed" do
    do_delete.should redirect_to("/linkbacks")
  end
  
  it "should raise InternalServerError if failed" do
    @linkback.stub!(:destroy).and_return(false)
    lambda { do_delete }.should raise_error(Merb::ControllerExceptions::InternalServerError)
  end
end




# Nested

require File.dirname(__FILE__) + '/../spec_helper'

describe BlogSlice::Linkbacks, "index action" do
  before :all do
    Merb::Router.prepare { |r| slice(:BlogSlice, :name_prefix => nil, :path_prefix => nil, :default_routes => false) } if standalone?
  end
  
  after :all do
    Merb::Router.reset! if standalone?
  end

  before :each do
    @post = mock('post')
    Post.stub!(:get).and_return(@post)

    @linkbacks = mock('linkbacks')
    @post.stub!(:linkbacks).and_return(@linkbacks)
  end
  
  def do_index
    dispatch_to(BlogSlice::Linkbacks, :index, :slug => 1) do |controller|
      controller.stub!(:display)
      yield controller if block_given?
    end
  end
  
  it "should have a route from /posts/1/linkbacks GET" do
    request_to('/posts/1/linkbacks', :get).should route_to("BlogSlice/linkbacks", :index)
  end
  
  it "should be successful" do
    do_index.should be_successful
  end
  
  it "should get the post from the database" do
    Post.should_receive(:get).with("1").and_return(@post)
    do_index
  end
  
  it "should raise NotFound if the post isn't found" do
    Post.stub!(:get).and_return(nil)
    lambda { do_index }.should raise_error(Merb::ControllerExceptions::NotFound)
  end
  
  it "should get the linkbacks from the database" do
    @post.should_receive(:linkbacks).with(no_args).and_return(@linkbacks)
    do_index
  end
  
  it "should render the linkbacks" do
    do_index do |controller|
      controller.should_receive(:display).with(@linkbacks)
    end
  end
  
  it "should assign the linkbacks to the view" do
    do_index.assigns(:linkbacks).should == @linkbacks
  end

  it "should assign the post parent to the view" do
    do_index.assigns(:post).should == @post
  end  
end

describe BlogSlice::Linkbacks, "show action" do
  before :all do
    Merb::Router.prepare { |r| slice(:BlogSlice, :name_prefix => nil, :path_prefix => nil, :default_routes => false) } if standalone?
  end
  
  after :all do
    Merb::Router.reset! if standalone?
  end

  before :each do
    @post = mock('post')
    Post.stub!(:get).and_return(@post)
    
    @linkbacks = mock('linkbacks')
    @post.stub!(:linkbacks).and_return(@linkbacks)
    
    @linkback = mock('linkback')
    @linkbacks.stub!(:get).and_return(@linkback)
  end
  
  it "should have a route from /posts/1/linkbacks/2 GET" do
    request_to('/posts/1/linkbacks/2', :get).should route_to("BlogSlice/linkbacks", :show)
  end
  
  def do_show
    dispatch_to(BlogSlice::Linkbacks, :show, :slug => 1, :id => 2) do |controller|
      controller.stub!(:display)
      yield controller if block_given?
    end
  end
  
  it "should be successful" do
    do_show.should be_successful
  end
  
  it "should get the post from the database" do
    Post.should_receive(:get).with("1").and_return(@post)
    do_show
  end
  
  it "should raise NotFound if the post isn't found" do
    Post.stub!(:get).and_return(nil)
    lambda { do_show }.should raise_error(Merb::ControllerExceptions::NotFound)
  end
  
  it "should get the linkback from the database" do
    @post.should_receive(:linkbacks).and_return(@linkbacks)
    @linkbacks.should_receive(:get).with("2").and_return(@linkback)
    do_show
  end
  
  it "should raise NotFound if the linkback isn't found" do
    @linkbacks.stub!(:get).and_return(nil)
    lambda { do_show }.should raise_error(Merb::ControllerExceptions::NotFound)
  end
  
  it "should assigns the linkback for the view" do
    do_show.assigns(:linkback).should == @linkback
  end

  it "should assign the post parent to the view" do
    do_show.assigns(:post).should == @post
  end  

  it "should display the linkback" do
    do_show do |controller|
      controller.should_receive(:display).with(@linkback)
    end
  end
end

describe BlogSlice::Linkbacks, "new action" do
  before :all do
    Merb::Router.prepare { |r| slice(:BlogSlice, :name_prefix => nil, :path_prefix => nil, :default_routes => false) } if standalone?
  end
  
  after :all do
    Merb::Router.reset! if standalone?
  end

  before :each do
    @post = mock('post')
    Post.stub!(:get).and_return(@post)
    
    @linkback = mock("linkback")
    Linkback.stub!(:new).and_return(@linkback)
  end
  
  it "should have a route from /posts/1/linkbacks/new GET" do
    request_to("/posts/1/linkbacks/new", :get).should route_to("BlogSlice/linkbacks", :new)
  end
  
  def do_new
    dispatch_to(BlogSlice::Linkbacks, :new, :slug => 1) do |controller|
      controller.stub!(:display)
      yield controller if block_given?
    end
  end
  
  it "should be successful" do
    do_new.should be_successful
  end
  
  it "should get the post from the database" do
    Post.should_receive(:get).with("1").and_return(@post)
    do_new
  end
  
  it "should raise NotFound if the post isn't found" do
    Post.stub!(:get).and_return(nil)
    lambda { do_new }.should raise_error(Merb::ControllerExceptions::NotFound)
  end
  
  it "should create a new linkback object" do
    Linkback.should_receive(:new).with(no_args).and_return(@linkback)
    do_new
  end
  
  it "should assigns the linkback object for the view" do
    do_new.assigns(:linkback).should == @linkback
  end

  it "should assign the post parent to the view" do
    do_new.assigns(:post).should == @post
  end  

  it "should render the linkback" do
    do_new do |controller|
      controller.should_receive(:display).with(@linkback, :form)
    end
  end
end

describe BlogSlice::Linkbacks, "edit action" do
  before :all do
    Merb::Router.prepare { |r| slice(:BlogSlice, :name_prefix => nil, :path_prefix => nil, :default_routes => false) } if standalone?
  end
  
  after :all do
    Merb::Router.reset! if standalone?
  end

  before :each do
    @post = mock('post')
    Post.stub!(:get).and_return(@post)
    
    @linkbacks = mock('linkbacks')
    @post.stub!(:linkbacks).and_return(@linkbacks)

    @linkback = mock("linkback")
    @linkbacks.stub!(:get).and_return(@linkback)
  end
  
  it "should have a route from /posts/1/linkbacks/2/edit GET" do
    request_to("/posts/1/linkbacks/2/edit", :get).should route_to("BlogSlice/linkbacks", :edit)
  end
  
  def do_edit
    dispatch_to(BlogSlice::Linkbacks, :edit, :slug => 1, :id => 2) do |controller|
      controller.stub!(:display)
      yield controller if block_given?
    end
  end
  
  it "should be successful" do
    do_edit.should be_successful
  end
  
  it "should get the post from the database" do
    Post.should_receive(:get).with("1").and_return(@post)
    do_edit
  end
  
  it "should raise NotFound if the post isn't found" do
    Post.stub!(:get).and_return(nil)
    lambda { do_edit }.should raise_error(Merb::ControllerExceptions::NotFound)
  end
  
  it "should get the linkback object" do
    @post.should_receive(:linkbacks).with(no_args).and_return(@linkbacks)
    @linkbacks.should_receive(:get).with("2").and_return(@linkback)
    do_edit
  end
  
  it "should raise NotFound if the linkback object isn't found" do
    @linkbacks.stub!(:get).and_return(nil)
    lambda { do_edit }.should raise_error(Merb::ControllerExceptions::NotFound)
  end
  
  it "should assigns the linkback object for the view" do
    do_edit.assigns(:linkback).should == @linkback
  end
  
  it "should assign the post parent to the view" do
    do_edit.assigns(:post).should == @post
  end  

  it "should render the linkback" do
    do_edit do |controller|
      controller.should_receive(:display).with(@linkback, :form)
    end
  end
end

describe BlogSlice::Linkbacks, 'create action' do
  before :all do
    Merb::Router.prepare { |r| slice(:BlogSlice, :name_prefix => nil, :path_prefix => nil, :default_routes => false) } if standalone?
  end
  
  after :all do
    Merb::Router.reset! if standalone?
  end

  before :each do
    @post = Post.new
    @post.stub!(:slug).and_return("1")
    Post.stub!(:get).with("1").and_return(@post)
    
    @linkback = Linkback.new
    @linkback.stub!(:save).and_return(true)
    @linkback.stub!(:id).and_return(2)
    Linkback.stub!(:new).and_return(@linkback)
  end
  
  it "should have a route from /posts/1/linkbacks POST" do
    request_to("/posts/1/linkbacks", :post).should route_to("BlogSlice/linkbacks", :create)
  end
  
  def attributes
    {"name" => "Expenses"}
  end
  
  def do_create
    dispatch_to(BlogSlice::Linkbacks, :create, :slug => 1, :linkback => attributes) do |controller|
      controller.stub!(:display)
      yield controller if block_given?
    end
  end
  
  it "should get the post from the database" do
    Post.should_receive(:get).with("1").and_return(@post)
    do_create
  end
  
  it "should raise NotFound if the post isn't found" do
    Post.stub!(:get).and_return(nil)
    lambda { do_create }.should raise_error(Merb::ControllerExceptions::NotFound)
  end
  
  it "should create a new linkback object" do
    Linkback.should_receive(:new).with(attributes).and_return(@linkback)
    do_create
  end
  
  it "should set the post" do
    @linkback.should_receive(:post=).with(@post)
    do_create
  end
  
  it "should try to save the linkback" do
    @linkback.should_receive(:save).with(no_args)
    do_create
  end
  
  it "should redirect to the newly created linkback if successful" do
    do_create.should redirect_to(resource(@post, @linkback), :message => {:notice => "Linkback was successfully created"})
  end
  
  it "should render the form if not successful" do
    @linkback.stub!(:save).and_return(false)
    do_create do |controller|
      controller.should_receive(:display).with(@linkback, :form)
    end.assigns(:linkback).should == @linkback
  end
  
  it "should assign the linkback to the view" do
    do_create.assigns(:linkback).should == @linkback
  end
  
  it "should assign the post parent to the view" do
    do_create.assigns(:post).should == @post
  end  
end

describe BlogSlice::Linkbacks, 'update' do
  before :all do
    Merb::Router.prepare { |r| slice(:BlogSlice, :name_prefix => nil, :path_prefix => nil, :default_routes => false) } if standalone?
  end
  
  after :all do
    Merb::Router.reset! if standalone?
  end

  before :each do
    @post = Post.new(:id => "1")
    Post.stub!(:get).with("1").and_return(@post)
  
    @linkbacks = mock("linkbacks")
    @post.stub!(:linkbacks).and_return(@linkbacks)
  
    @linkback = Linkback.new(:id => "2")
    @linkbacks.stub!(:get).and_return(@linkback)
    
    @linkback.stub!(:update_attributes).and_return(true)
  end
  
  it "should have a route from /posts/1/linkbacks/2 PUT" do
    request_to("/posts/1/linkbacks/2", :put).should route_to("BlogSlice/linkbacks", :update)
  end
  
  def attributes
    {"name" => "Expenses"}
  end
  
  def do_update
    dispatch_to(BlogSlice::Linkbacks, :update, :slug => 1, :id => 2, :linkback => attributes) do |controller|
      controller.stub!(:display)
      yield controller if block_given?
    end
  end
  
  it "should get the post from the database" do
    Post.should_receive(:get).with("1").and_return(@post)
    do_update
  end
  
  it "should raise NotFound if the post isn't found" do
    Post.stub!(:get).and_return(nil)
    lambda { do_update }.should raise_error(Merb::ControllerExceptions::NotFound)
  end
  
  it "should get the linkback from the database" do
    @post.should_receive(:linkbacks).and_return(@linkbacks)
    @linkbacks.should_receive(:get).and_return(@linkback)
    do_update
  end
  
  it "should raise NotFound if the linkback isn't found" do
    @linkbacks.stub!(:get).and_return(nil)
    lambda { do_update }.should raise_error(Merb::ControllerExceptions::NotFound)
  end
  
  it "should try to save the linkback" do
    @linkback.should_receive(:update_attributes).with(attributes)
    do_update
  end
  
  it "should redirect to the linkback if successful" do
    do_update.should redirect_to("/posts/1/linkbacks/2")
  end
  
  it "should render the form if the linkback can't be saved" do
    @linkback.stub!(:update_attributes).and_return(false)
    do_update do |controller|
      controller.should_receive(:display).with(@linkback, :form)
    end
  end
  
  it "should assign the linkback to the view" do
    do_update.assigns(:linkback).should == @linkback
  end
  
  it "should assign the post parent to the view" do
    do_update.assigns(:post).should == @post
  end  
end

describe BlogSlice::Linkbacks, 'destroy' do
  before :all do
    Merb::Router.prepare { |r| slice(:BlogSlice, :name_prefix => nil, :path_prefix => nil, :default_routes => false) } if standalone?
  end
  
  after :all do
    Merb::Router.reset! if standalone?
  end

  before :each do
    @post = Post.new(:id => "1")
    Post.stub!(:get).with("1").and_return(@post)
    
    @linkbacks = mock("linkbacks")
    @post.stub!(:linkbacks).and_return(@linkbacks)
  
    @linkback = Linkback.new(:id => "2")
    @linkbacks.stub!(:get).and_return(@linkback)
    
    @linkback.stub!(:destroy).and_return(true)
  end
  
  it "should have a route from /posts/1/linkbacks/2 DELETE" do
    request_to("/posts/1/linkbacks/2", :delete).should route_to("BlogSlice/linkbacks", :destroy)
  end
  
  def do_delete
    dispatch_to(BlogSlice::Linkbacks, :destroy, :slug => 1, :id => 2) do |controller|
      yield controller if block_given?
    end
  end
  
  it "should get the post from the database" do
    Post.should_receive(:get).with("1").and_return(@post)
    do_delete
  end
  
  it "should raise NotFound if the post isn't found" do
    Post.stub!(:get).and_return(nil)
    lambda { do_delete }.should raise_error(Merb::ControllerExceptions::NotFound)
  end
  
  it "should get the linkback from the database" do
    @post.should_receive(:linkbacks).and_return(@linkbacks)
    @linkbacks.should_receive(:get).and_return(@linkback)
    do_delete
  end
  
  it "should raise NotFound if the linkback isn't found" do
    @linkbacks.stub!(:get).and_return(nil)
    lambda { do_delete }.should raise_error(Merb::ControllerExceptions::NotFound)
  end
  
  it "should try to delete the linkback" do
    @linkback.should_receive(:destroy)
    do_delete
  end
  
  it "should redirect to the linkbacks list if destroyed" do
    do_delete.should redirect_to("/posts/1/linkbacks")
  end
  
  it "should raise InternalServerError if failed" do
    @linkback.stub!(:destroy).and_return(false)
    lambda { do_delete }.should raise_error(Merb::ControllerExceptions::InternalServerError)
  end
end