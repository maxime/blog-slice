require File.dirname(__FILE__) + '/../../spec_helper'

describe "categories/show, authorized" do
  before :all do
    Merb::Router.prepare { |r| slice(:BlogSlice, :name_prefix => nil, :path_prefix => nil, :default_routes => false) } if standalone?
  end

  after :all do
    Merb::Router.reset! if standalone?
  end
  
  before(:each) do                    
    @controller = BlogSlice::Categories.new(fake_request)
    @category = Category.new({:name=>"noncoagulable", :id=>0, :slug => 'noncoagulable'})

    post =Post.new(:title => "my first blog post", :rendered_content => "bla", :published_at => Time.now, :slug => 'my-first-blog-post')
    post.stub!(:comments).and_return([])
    posts = [post]
    posts.stub!(:total_pages).and_return(1)

    @controller.instance_variable_set(:@posts, posts)
    
    @controller.instance_variable_set(:@category, @category)
    @body = @controller.render(:show) 
  end
  
  it "should display the title" do
    @body.should have_tag(:h1) {|h1| h1.should contain("Categories")}
    @body.should have_tag(:h1) {|h1| h1.should contain("noncoagulable")}
  end

  it "should display the link to edit the category" do
    @body.should have_tag(:a, :href => '/categories/noncoagulable/edit')
  end
end


describe "categories/show, non authorized" do
  before :all do
    Merb::Router.prepare { |r| slice(:BlogSlice, :name_prefix => nil, :path_prefix => nil, :default_routes => false) } if standalone?
  end

  after :all do
    Merb::Router.reset! if standalone?
  end
  
  before(:each) do                    
    @controller = BlogSlice::Categories.new(fake_request)
    @category = Category.new({:name=>"noncoagulable", :id=>0, :slug => 'noncoagulable'})

    post =Post.new(:title => "my first blog post", :rendered_content => "bla", :published_at => Time.now, :slug => 'my-first-blog-post')
    post.stub!(:comments).and_return([])
    posts = [post]
    posts.stub!(:total_pages).and_return(1)

    @controller.instance_variable_set(:@posts, posts)

    @controller.stub!(:authorized?).and_return(false)
    @controller.instance_variable_set(:@category, @category)
    @body = @controller.render(:show) 
  end
  
  it "should display the title" do
    @body.should have_tag(:h1) {|h1| h1.should contain("Posts categorized as")}
    @body.should have_tag(:h1) {|h1| h1.should contain("noncoagulable")}
  end

  it "should not display the link to edit the category" do
    @body.should_not have_tag(:a, :href => '/categories/noncoagulable/edit')
  end
end

