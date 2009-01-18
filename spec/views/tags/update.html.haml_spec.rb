require File.dirname(__FILE__) + '/../../spec_helper'

describe 'tags/update' do
  before :all do
    Merb::Router.prepare { |r| slice(:BlogSlice, :name_prefix => nil, :path_prefix => nil, :default_routes => false) } if standalone?
  end

  after :all do
    Merb::Router.reset! if standalone?
  end
  
  before :each do
    @controller = BlogSlice::Tags.new(fake_request)
    
    @tag = Tag.new(:id => 1, :slug => 'chocolate', :name => 'Chocolate')
    
    @tag.stub!(:errors).and_return({:name => "Can't be blank", :something => "Is already taken"})
    
    @controller.instance_variable_set(:@tag, @tag) 
    
    @body = @controller.render(:update)
  end

  it "should display the errors" do
    @body.should contain("Can't be blank")
    @body.should contain("Is already taken")
  end
end