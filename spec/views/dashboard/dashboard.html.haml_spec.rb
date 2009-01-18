require File.join(File.dirname(__FILE__), "../..", 'spec_helper.rb')

describe "dashboard/dashboard authorized" do 
  before :all do
    Merb::Router.prepare { |r| slice(:BlogSlice, :name_prefix => nil, :path_prefix => nil, :default_routes => false) } if standalone?
  end

  after :all do
    Merb::Router.reset! if standalone?
  end
  
  before(:each) do                    
    @controller = BlogSlice::Dashboard.new(fake_request) 
    Post.stub!(:count).and_return(3)
    Comment.stub!(:count).and_return(33)
    Tag.stub!(:count).and_return(8)
    Category.stub!(:count).and_return(6)
    Post.stub!(:all).and_return([])
    Comment.stub!(:all).and_return([])
    Tag.stub!(:all).and_return([])
    
    @dashboard = {:left => [:numbers, :posts, :drafts], :right => [:tags, :comments]}
    
    @controller.instance_variable_set(:@dashboard, @dashboard) 
    @body = @controller.render(:dashboard) 
  end 
 
  it "should display the title" do
    @body.should have_tag(:h1) {|h1| h1.should contain("Dashboard")}
  end
  
  it "should display the different components" do
    ["At a glance", "Posts", "Drafts", "Tags", "Comments"].each do |component|
      @body.should contain(component)
    end
  end
end
