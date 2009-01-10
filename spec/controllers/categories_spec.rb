require File.dirname(__FILE__) + '/../spec_helper'

describe BlogSlice::Categories, "index action" do
  before :all do
    Merb::Router.prepare { |r| slice(:BlogSlice, :name_prefix => nil, :path_prefix => nil, :default_routes => false) } if standalone?
  end
  
  after :all do
    Merb::Router.reset! if standalone?
  end
  
  before :each do
    @categories = mock('categories')
    Category.stub!(:all).and_return(@categories)
  end
  
  def do_index
    dispatch_to(BlogSlice::Categories, :index) do |controller|
      controller.stub!(:display)
      yield controller if block_given?
    end
  end
  
  it "should have a route from /categories GET" do
    request_to('/categories', :get).should route_to('BlogSlice/categories', :index)
  end
  
  it "should be successful" do
    do_index.should be_successful
  end
  
  it "should get the BlogSlice::Categories from the database" do
    Category.should_receive(:all).with(no_args).and_return(@categories)
    do_index
  end
  
  it "should render the BlogSlice::Categories" do
    do_index do |controller|
      controller.should_receive(:display).with(@categories)
    end
  end
  
  it "should assign the BlogSlice::Categories to the view" do
    do_index.assigns(:categories).should == @categories
  end
end

describe BlogSlice::Categories, "show action" do
  before :all do
    Merb::Router.prepare { |r| slice(:BlogSlice, :name_prefix => nil, :path_prefix => nil, :default_routes => false) } if standalone?
  end
  
  after :all do
    Merb::Router.reset! if standalone?
  end
  
  before :each do
    @category = mock('category')
    Category.stub!(:first).and_return(@category)

    @posts = mock('posts')
    @category.stub!(:posts).and_return(@posts)
    @posts.stub!(:paginate).and_return([])
  end
  
  it "should have a route from /categories/1 GET" do
    request_to('/categories/1', :get).should route_to('BlogSlice/categories', :show)
  end
  
  def do_show
    dispatch_to(BlogSlice::Categories, :show, :slug => 'it') do |controller|
      controller.stub!(:display)
      yield controller if block_given?
    end
  end
  
  it "should be successful" do
    do_show.should be_successful
  end
  
  it "should get the Category from the database" do
    Category.should_receive(:first).with(:slug => 'it').and_return(@category)
    do_show
  end
  
  it "should raise NotFound if the Category isn't found" do
    Category.stub!(:first).and_return(nil)
    lambda { do_show }.should raise_error(Merb::ControllerExceptions::NotFound)
  end
  
  it "should assigns the Category for the view" do
    do_show.assigns(:category).should == @category
  end
  
  it "should get the posts associated to the category" do
    @category.should_receive(:posts).with(no_args).and_return(@posts)
    @posts.should_receive(:paginate).with({:order=>[:published_at.desc], :page=>nil}).and_return([])
    do_show
  end
  
  it "should display the category" do
    do_show do |controller|
      controller.should_receive(:display).with(@category)
    end
  end
end

describe BlogSlice::Categories, "new action, unauthorized" do
  it "should raise Unauthorized" do
    lambda do
      dispatch_to(BlogSlice::Categories, :new) do |controller|
        controller.stub!(:authorized?).and_return(false)
        controller.stub!(:render)
      end
    end.should raise_error(Merb::ControllerExceptions::Unauthorized)
  end
end

describe BlogSlice::Categories, "new action, authorized" do
  before :all do
    Merb::Router.prepare { |r| slice(:BlogSlice, :name_prefix => nil, :path_prefix => nil, :default_routes => false) } if standalone?
  end
  
  after :all do
    Merb::Router.reset! if standalone?
  end
  
  before :each do
    @category = mock("category")
    Category.stub!(:new).and_return(@category)
  end
  
  it "should have a route from /categories/new GET" do
    request_to("/categories/new", :get).should route_to('BlogSlice/categories', :new)
  end
  
  def do_new
    dispatch_to(BlogSlice::Categories, :new) do |controller|
      controller.stub!(:display)
      yield controller if block_given?
    end
  end
  
  it "should be successful" do
    do_new.should be_successful
  end
  
  it "should create a new Category object" do
    Category.should_receive(:new).with(no_args).and_return(@category)
    do_new
  end
  
  it "should assigns the Category object for the view" do
    do_new.assigns(:category).should == @category
  end
  
  it "should render the Category" do
    do_new do |controller|
      controller.should_receive(:display).with(@category, :form)
    end
  end
end

describe BlogSlice::Categories, "edit action, unauthorized" do
  it "should raise Unauthorized" do
    lambda do
      dispatch_to(BlogSlice::Categories, :edit) do |controller|
        controller.stub!(:authorized?).and_return(false)
        controller.stub!(:render)
      end
    end.should raise_error(Merb::ControllerExceptions::Unauthorized)
  end
end

describe BlogSlice::Categories, "edit action, authorized" do
  before :all do
    Merb::Router.prepare { |r| slice(:BlogSlice, :name_prefix => nil, :path_prefix => nil, :default_routes => false) } if standalone?
  end
  
  after :all do
    Merb::Router.reset! if standalone?
  end
  
  before :each do
    @category = mock("category")
    Category.stub!(:first).and_return(@category)
  end
  
  it "should have a route from /categories/1/edit GET" do
    request_to("/categories/1/edit", :get).should route_to('BlogSlice/categories', :edit)
  end
  
  def do_edit
    dispatch_to(BlogSlice::Categories, :edit, :slug => 'it') do |controller|
      controller.stub!(:display)
      yield controller if block_given?
    end
  end
  
  it "should be successful" do
    do_edit.should be_successful
  end
  
  it "should get the Category object" do
    Category.should_receive(:first).with(:slug => 'it').and_return(@category)
    do_edit
  end
  
  it "should raise NotFound if the Category object isn't found" do
    Category.stub!(:first).and_return(nil)
    lambda { do_edit }.should raise_error(Merb::ControllerExceptions::NotFound)
  end
  
  it "should assigns the Category object for the view" do
    do_edit.assigns(:category).should == @category
  end
  
  it "should render the Category" do
    do_edit do |controller|
      controller.should_receive(:display).with(@category, :form)
    end
  end
end

describe BlogSlice::Categories, "create action, unauthorized" do
  it "should raise Unauthorized" do
    lambda do
      dispatch_to(BlogSlice::Categories, :create) do |controller|
        controller.stub!(:authorized?).and_return(false)
        controller.stub!(:render)
      end
    end.should raise_error(Merb::ControllerExceptions::Unauthorized)
  end
end

describe BlogSlice::Categories, 'create action, authorized' do
  before :all do
    Merb::Router.prepare { |r| slice(:BlogSlice, :name_prefix => nil, :path_prefix => nil, :default_routes => false) } if standalone?
  end
  
  after :all do
    Merb::Router.reset! if standalone?
  end
  
  before :each do
    @category = Category.new
    @category.stub!(:save).and_return(true)
    @category.stub!(:slug).and_return('bla')
    
    Category.stub!(:new).and_return(@category)
  end
  
  it "should have a route from /categories POST" do
    request_to("/categories", :post).should route_to('BlogSlice/categories', :create)
  end
  
  def attributes
    {"name" => "some name"}
  end
  
  def do_create
    dispatch_to(BlogSlice::Categories, :create, :category => attributes) do |controller|
      controller.stub!(:display)
      yield controller if block_given?
    end
  end
  
  it "should create a new Category object" do
    Category.should_receive(:new).with(attributes).and_return(@category)
    do_create
  end
  
  it "should try to save the Category" do
    @category.should_receive(:save).with(no_args)
    do_create
  end
  
  it "should redirect to the newly created Category if successful" do
    do_create.should redirect_to(resource(@category), :message => {:notice => "Category was successfully created"})
  end
  
  it "should render the form if not successful" do
    @category.stub!(:save).and_return(false)
    do_create do |controller|
      controller.should_receive(:display).with(@category, :form)
    end
  end
  
  it "should assign the Category to the view" do
    do_create.assigns(:category).should == @category
  end
end

describe BlogSlice::Categories, "update action, unauthorized" do
  it "should raise Unauthorized" do
    lambda do
      dispatch_to(BlogSlice::Categories, :update) do |controller|
        controller.stub!(:authorized?).and_return(false)
        controller.stub!(:render)
      end
    end.should raise_error(Merb::ControllerExceptions::Unauthorized)
  end
end

describe BlogSlice::Categories, 'update, authorized' do
  before :all do
    Merb::Router.prepare { |r| slice(:BlogSlice, :name_prefix => nil, :path_prefix => nil, :default_routes => false) } if standalone?
  end
  
  after :all do
    Merb::Router.reset! if standalone?
  end
  
  before :each do
    @category = Category.new(:id => "1")
    Category.stub!(:first).and_return(@category)
    
    @category.stub!(:update_attributes).and_return(true)
  end
  
  it "should have a route from /categories/1 PUT" do
    request_to("/categories/1", :put).should route_to('BlogSlice/categories', :update)
  end
  
  def attributes
    {"name" => "some name"}
  end
  
  def do_update
    dispatch_to(BlogSlice::Categories, :update, :slug => "it", :category => attributes) do |controller|
      controller.stub!(:display)
      yield controller if block_given?
    end
  end
  
  it "should get the Category from the database" do
    Category.should_receive(:first).with(:slug => "it").and_return(@category)
    do_update
  end
  
  it "should raise NotFound if the Category isn't found" do
    Category.stub!(:first).and_return(nil)
    lambda { do_update }.should raise_error(Merb::ControllerExceptions::NotFound)
  end
  
  it "should try to save the Category" do
    @category.should_receive(:update_attributes).with(attributes)
    do_update
  end
  
  it "should redirect to the Category if successful" do
    do_update.should redirect_to("/categories/it")
  end
  
  it "should render the form if the Category can't be saved" do
    @category.stub!(:update_attributes).and_return(false)
    do_update do |controller|
      controller.should_receive(:display).with(@category, :form)
    end
  end
  
  it "should assign the Category to the view" do
    do_update.assigns(:category).should == @category
  end
end

describe BlogSlice::Categories, "destroy action, unauthorized" do
  it "should raise Unauthorized" do
    lambda do
      dispatch_to(BlogSlice::Categories, :destroy) do |controller|
        controller.stub!(:authorized?).and_return(false)
        controller.stub!(:render)
      end
    end.should raise_error(Merb::ControllerExceptions::Unauthorized)
  end
end

describe BlogSlice::Categories, 'destroy' do
  before :all do
    Merb::Router.prepare { |r| slice(:BlogSlice, :name_prefix => nil, :path_prefix => nil, :default_routes => false) } if standalone?
  end
  
  after :all do
    Merb::Router.reset! if standalone?
  end
  
  before :each do
    @category = Category.new(:id => "1")
    Category.stub!(:first).and_return(@category)
    
    @category.stub!(:destroy).and_return(true)
  end
  
  it "should have a route from /categories/1 DELETE" do
    request_to("/categories/1", :delete).should route_to('BlogSlice/categories', :destroy)
  end
  
  def do_delete
    dispatch_to(BlogSlice::Categories, :destroy, :id => 1) do |controller|
      yield controller if block_given?
    end
  end
  
  it "should get the Category from the database" do
    Category.should_receive(:first).and_return(@category)
    do_delete
  end
  
  it "should raise NotFound if the Category isn't found" do
    Category.stub!(:first).and_return(nil)
    lambda { do_delete }.should raise_error(Merb::ControllerExceptions::NotFound)
  end
  
  it "should try to delete the Category" do
    @category.should_receive(:destroy)
    do_delete
  end
  
  it "should redirect to the BlogSlice::Categories list if destroyed" do
    do_delete.should redirect_to("/categories")
  end
  
  it "should raise InternalServerError if failed" do
    @category.stub!(:destroy).and_return(false)
    lambda { do_delete }.should raise_error(Merb::ControllerExceptions::InternalServerError)
  end
end