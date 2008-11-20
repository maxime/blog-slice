require File.dirname(__FILE__) + '/../../spec_helper'

describe 'tags/index' do
  before :all do
    Merb::Router.prepare { |r| slice(:BlogSlice, :name_prefix => nil, :path_prefix => nil, :default_routes => false) } if standalone?
  end

  after :all do
    Merb::Router.reset! if standalone?
  end
  
  before :each do
    @controller = BlogSlice::Tags.new(fake_request)
    
    first_tag = Tag.new(:id => 1, :slug => 'chocolate', :name => 'Chocolate')
    first_tag.stub!(:posts).and_return([1])
    second_tag = Tag.new(:id => 2, :slug => 'technology', :name => 'Technology')
    second_tag.stub!(:posts).and_return([1])
    
    @controller.instance_variable_set(:@tags, [first_tag, second_tag]) 
    
    @body = @controller.render(:index)
  end
  
  it "should have a title" do
    @body.should have_tag(:h1) {|h1| h1.should contain('Tags')}
  end
  
  it "should render the two tags" do
    @body.should have_tag(:a, :href => '/tags/chocolate') {|a| a.should contain("Chocolate") }
    @body.should have_tag(:a, :href => '/tags/technology') {|a| a.should contain("Technology") }
  end
end