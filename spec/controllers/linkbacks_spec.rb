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


describe BlogSlice::Linkbacks, "approve action" do
  before :all do
    Merb::Router.prepare { |r| slice(:BlogSlice, :name_prefix => nil, :path_prefix => nil, :default_routes => false) } if standalone?
  end
  
  after :all do
    Merb::Router.reset! if standalone?
  end

  before :each do
    @linkback = mock('linkback')
    Linkback.stub!(:get).and_return(@linkback)
    @linkback.stub!(:update_attributes)
  end
  
  it "should have a route from /linkbacks/1/approve POST" do
    request_to('/linkbacks/1/approve', :post).should route_to("BlogSlice/linkbacks", :approve)
  end
  
  def do_approve
    dispatch_to(BlogSlice::Linkbacks, :approve, :id => 1) do |controller|
      controller.stub!(:display)
      yield controller if block_given?
    end
  end
  
  it "should get the Linkback from the database" do
    Linkback.should_receive(:get).with("1").and_return(@linkback)
    do_approve
  end
  
  it "should raise NotFound if the Linkback isn't found" do
    Linkback.stub!(:get).and_return(nil)
    lambda { do_approve }.should raise_error(Merb::ControllerExceptions::NotFound)
  end
  
  it "should approve the linkback" do
    @linkback.should_receive(:update_attributes).with(:approved => true)
    do_approve
  end
  
  it "should redirect to the dashboard" do
    do_approve.should redirect_to('/dashboard')
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