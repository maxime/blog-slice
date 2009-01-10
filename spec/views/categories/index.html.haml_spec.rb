require File.dirname(__FILE__) + '/../../spec_helper'

describe "categories/index, authorized" do
  before :all do
    Merb::Router.prepare { |r| slice(:BlogSlice, :name_prefix => nil, :path_prefix => nil, :default_routes => false) } if standalone?
  end

  after :all do
    Merb::Router.reset! if standalone?
  end
  
  before(:each) do                    
    @controller = BlogSlice::Categories.new(fake_request)
    
    @first_category = Category.new({:name=>"anilopyrin", :id=>1, :slug => 'anilopyrin'})
    @second_category = Category.new({:name=>"colorable", :id=>7, :slug => 'colorable'})
    
    @categories = [@first_category, @second_category]
    
    @controller.instance_variable_set(:@categories, @categories)
    @body = @controller.render(:index) 
  end
  
  it "should display the BlogSlice::Categories title" do
    @body.should have_tag(:h1) {|h1| h1.should contain("Categories")}
  end
  
  it "should display the different categories" do
    @body.should have_tag(:div, :id => "category_#{@first_category.id}") {|tr| tr.should contain(@first_category.name.to_s) }
    @body.should have_tag(:div, :id => "category_#{@second_category.id}") {|tr| tr.should contain(@second_category.name.to_s) }
  end
  
  it "should display the create a new category link" do
    @body.should have_tag(:a, :href => '/categories/new')
  end
  
  it "should display links for editing and destroying categories" do
    @body.should have_tag(:a, :href => '/categories/anilopyrin/edit')
    @body.should have_tag(:a, :href => '/categories/colorable/edit')
    @body.should have_tag(:a, :href => '/categories/anilopyrin', :method => :delete)
    @body.should have_tag(:a, :href => '/categories/colorable', :method => :delete)
  end
end

describe "categories/index, authorized" do
  before :all do
    Merb::Router.prepare { |r| slice(:BlogSlice, :name_prefix => nil, :path_prefix => nil, :default_routes => false) } if standalone?
  end

  after :all do
    Merb::Router.reset! if standalone?
  end
  
  before(:each) do                    
    @controller = BlogSlice::Categories.new(fake_request)
    
    @first_category = Category.new({:name=>"anilopyrin", :id=>1, :slug => 'anilopyrin'})
    @second_category = Category.new({:name=>"colorable", :id=>7, :slug => 'colorable'})
    
    @categories = [@first_category, @second_category]
    
    @controller.instance_variable_set(:@categories, @categories)
    @controller.stub!(:authorized?).and_return(false)
    @body = @controller.render(:index) 
  end
  
  it "should display the BlogSlice::Categories title" do
    @body.should have_tag(:h1) {|h1| h1.should contain("Categories")}
  end
  
  it "should display the different categories" do
    @body.should have_tag(:div, :id => "category_#{@first_category.id}") {|tr| tr.should contain(@first_category.name.to_s) }
    @body.should have_tag(:div, :id => "category_#{@second_category.id}") {|tr| tr.should contain(@second_category.name.to_s) }
  end
  
  it "should not display the create a new category link" do
    @body.should_not have_tag(:a, :href => '/categories/new')
  end
  
  it "should display links for editing and destroying categories" do
    @body.should_not have_tag(:a, :href => '/categories/anilopyrin/edit')
    @body.should_not have_tag(:a, :href => '/categories/colorable/edit')
    @body.should_not have_tag(:a, :href => '/categories/anilopyrin', :method => :delete)
    @body.should_not have_tag(:a, :href => '/categories/colorable', :method => :delete)
  end
end

