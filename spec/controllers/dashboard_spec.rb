require File.dirname(__FILE__) + '/../spec_helper'

describe BlogSlice::Dashboard, 'dashboard' do
  before :all do
    Merb::Router.prepare { |r| slice(:BlogSlice, :name_prefix => nil, :path_prefix => nil, :default_routes => false) } if standalone?
  end
  
  after :all do
    Merb::Router.reset! if standalone?
  end
  
  before :each do
    
  end
  
  def do_get
    dispatch_to(BlogSlice::Dashboard, :dashboard) do |controller|
      controller.stub!(:render)
      yield controller if block_given?
    end
  end
  
  it "should have a route from /dashboard GET" do
    request_to('/dashboard', :get).should route_to('BlogSlice/dashboard', :dashboard)
  end
end