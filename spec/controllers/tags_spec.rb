require File.dirname(__FILE__) + '/../spec_helper'

describe BlogSlice::Tags, 'index action' do
  before :all do
    Merb::Router.prepare { |r| slice(:BlogSlice, :name_prefix => nil, :path_prefix => nil, :default_routes => false) } if standalone?
  end
  
  after :all do
    Merb::Router.reset! if standalone?
  end
  
  before :each do
    @tags = mock('tags')
    Tag.stub!(:all).and_return(@tags)
  end
  
  def do_index
    dispatch_to(BlogSlice::Tags, :index) do |controller|
      controller.stub!(:display)
      yield controller if block_given?
    end
  end
  
  it "should have a route from /tags GET" do
    request_to('/tags', :get).should route_to('BlogSlice/Tags', :index)
  end
  
  it "should get the tags from the database" do
    Tag.should_receive(:all).with(no_args).and_return(@tags)
    do_index
  end
  
  it "should display the tags" do
    do_index do |controller|
      controller.should_receive(:display).with(@tags)
    end
  end
  
  it "should assigns the tags to the view" do
    do_index.assigns(:tags).should == @tags
  end
end

describe BlogSlice::Tags, 'show action' do
  before :all do
    Merb::Router.prepare { |r| slice(:BlogSlice, :name_prefix => nil, :path_prefix => nil, :default_routes => false) } if standalone?
  end
  
  after :all do
    Merb::Router.reset! if standalone?
  end
  
  before :each do
    @tag = Tag.new(:id => 1, :name => "Chocolate", :slug => "chocolate")
    Tag.stub!(:first).and_return(@tag)
    @posts = mock('posts')
    @p = mock('p')
    @tag.stub!(:posts).and_return(@p)
    @p.stub!(:paginate).and_return(@posts)
  end
  
  def do_show
    dispatch_to(BlogSlice::Tags, :show, :slug => 'chocolate') do |controller|
      controller.stub!(:display)
      yield controller if block_given?
    end
  end
  
  it "should have a route from /tags/chocolate GET" do
    request_to('/tags/chocolate', :get).should route_to('BlogSlice/Tags', :show).with(:slug => 'chocolate')
  end
  
  it "should get the tag from the database" do
    Tag.should_receive(:first).with(:slug => 'chocolate').and_return(@tag)
    do_show
  end
  
  it "should get the posts related to this tag" do
    @tag.should_receive(:posts).with(no_args).and_return(@p)
    @p.should_receive(:paginate).with(:order => [:published_at.desc], :page => nil).and_return(@posts)
    do_show
  end
  
  it "should display the posts related to the tag" do
    do_show do |controller|
      controller.should_receive(:display).with(@posts)
    end
  end
  
  it "should assigns the tag and the posts to the view" do
    do_show.assigns(:tag) == @tag
    do_show.assigns(:posts) == @posts    
  end
end


describe BlogSlice::Tags, 'update action' do
  before :all do
    Merb::Router.prepare { |r| slice(:BlogSlice, :name_prefix => nil, :path_prefix => nil, :default_routes => false) } if standalone?
  end
  
  after :all do
    Merb::Router.reset! if standalone?
  end
  
  before :each do
    @tag = Tag.new(:id => 1, :name => "Chocolate", :slug => "chocolate")
    Tag.stub!(:first).and_return(@tag)
    
    @tag.stub!(:name=).and_return(true)
    @tag.stub!(:save).and_return(true)
    @tag.stub!(:name).and_return('Sweet')
  end
  
  def do_update
    dispatch_to(BlogSlice::Tags, :update, :slug => 'chocolate', :update_value => 'Sweet') do |controller|
      controller.stub!(:render)
      yield controller if block_given?
    end
  end
  
  it "should have a route from /tags/chocolate PUT" do
    request_to('/tags/chocolate', :put).should route_to('BlogSlice/Tags', :update).with(:slug => 'chocolate')
  end
  
  it "should get the tag from the database" do
    Tag.should_receive(:first).with(:slug => 'chocolate').and_return(@tag)
    do_update
  end
  
  it "should raise NotFound if the tag isn't found" do
    Tag.stub!(:first).and_return(nil)
    lambda { do_update }.should raise_error(Merb::ControllerExceptions::NotFound)
  end
  
  it "should set the tag name" do
    @tag.should_receive(:name=).with("Sweet")
    do_update
  end
  
  it "should render the tag name if the update is successful" do
    do_update.body.should == "Sweet"
  end
  
  it "should render the update template if the update isn't successful" do
    @tag.stub!(:save).and_return(false)
    
    do_update do |controller|
      controller.should_receive(:render).with(:update, :status => 500, :layout => false)
    end
  end
  
  it "should assigns the tag to the view" do
    do_update.assigns(:tag) == @tag
  end
end