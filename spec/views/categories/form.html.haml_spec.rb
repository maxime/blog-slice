require File.dirname(__FILE__) + '/../../spec_helper'

describe "categories/form" do
  before :all do
    Merb::Router.prepare { |r| slice(:BlogSlice, :name_prefix => nil, :path_prefix => nil, :default_routes => false) } if standalone?
  end

  after :all do
    Merb::Router.reset! if standalone?
  end
  
  before(:each) do                    
    @controller = BlogSlice::Categories.new(fake_request)
    @category = Category.new({:name=>"capanna", :id=>1, :slug => 'capanna'})
    @controller.instance_variable_set(:@category, @category)

    @body = @controller.render(:form)
  end
  
  it "should display the title" do
    @body.should have_tag(:h1) {|h1| h1.should contain("Create")}
  end
  
  it "should display a form" do
    @body.should have_tag(:form, :action => '/categories')
  end
  
  it "should have a text field for inputting the name" do
    @body.should have_tag(:input, :type=>"text", :id => 'category_name')
  end
end