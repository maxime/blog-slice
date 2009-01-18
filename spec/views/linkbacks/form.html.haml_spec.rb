require File.dirname(__FILE__) + '/../../spec_helper'

describe "linkbacks/form" do
  before :all do
    Merb::Router.prepare { |r| slice(:BlogSlice, :name_prefix => nil, :path_prefix => nil, :default_routes => false) } if standalone?
  end

  after :all do
    Merb::Router.reset! if standalone?
  end
  
  before(:each) do                    
    @controller = BlogSlice::Linkbacks.new(fake_request)
    @linkback = Linkback.new({:type=>"brachystomatous", :target_url=>"broiderer", :title=>"unsoldierlike", :source_url=>"Podolian", :excerpt=>"Precardiac uninstructiveness atheology stereogram adhamant lemmitis undepraved exoenzyme ugliness pertinent decadally legitimatize gamelion persecutional priority leucitite", :id=>0, :blog_name=>"deorganize"})
    @controller.instance_variable_set(:@linkback, @linkback)
    
    @body = @controller.render(:form) 
  end
  
  it "should display the title" do
    @body.should have_tag(:h1) {|h1| h1.should contain("Create")}
  end
  
  it "should display a form" do
    @body.should have_tag(:form, :action => '/linkbacks')
  end
  
  it "should have a text field for inputting the blog_name" do
    @body.should have_tag(:input, :type=>"text", :id => 'linkback_blog_name')
  end
  it "should have a text field for inputting the target_url" do
    @body.should have_tag(:input, :type=>"text", :id => 'linkback_target_url')
  end
  it "should have a text field for inputting the title" do
    @body.should have_tag(:input, :type=>"text", :id => 'linkback_title')
  end
  it "should have a text field for inputting the source_url" do
    @body.should have_tag(:input, :type=>"text", :id => 'linkback_source_url')
  end
  it "should have a text field for inputting the type" do
    @body.should have_tag(:input, :type=>"text", :id => 'linkback_type')
  end
  it "should have a text_area field for inputting the excerpt" do
    @body.should have_tag(:textarea, :id => 'linkback_excerpt')
  end
end


describe "linkbacks/form, post as parent" do
  before :all do
    Merb::Router.prepare { |r| slice(:BlogSlice, :name_prefix => nil, :path_prefix => nil, :default_routes => false) } if standalone?
  end

  after :all do
    Merb::Router.reset! if standalone?
  end
  
  before(:each) do                    
    @controller = BlogSlice::Linkbacks.new(fake_request)
    
    @post = Post.new(:slug => 'my-first-blog-post')
    @linkback = Linkback.new({:type=>"perineoscrotal", :target_url=>"malleal", :title=>"purveyal", :source_url=>"mimic", :excerpt=>"Signum guemal wulfenite thromboplastic rusine aurothiosulphuric ostiolate", :id=>0, :blog_name=>"integrate"})
    @linkback.stub!(:post).and_return(@post)
    
    @controller.instance_variable_set(:@linkback, @linkback)
    @controller.instance_variable_set(:@post, @post)
    
    @body = @controller.render(:form) 
  end
  
  it "should display the title" do
    @body.should have_tag(:h1) {|h1| h1.should contain("Create")}
  end
  
  it "should display a form" do
    @body.should have_tag(:form, :action => '/posts/my-first-blog-post/linkbacks')
  end
  
  it "should have a text field for inputting the blog_name" do
    @body.should have_tag(:input, :type=>"text", :id => 'linkback_blog_name')
  end
  it "should have a text field for inputting the target_url" do
    @body.should have_tag(:input, :type=>"text", :id => 'linkback_target_url')
  end
  it "should have a text field for inputting the title" do
    @body.should have_tag(:input, :type=>"text", :id => 'linkback_title')
  end
  it "should have a text field for inputting the source_url" do
    @body.should have_tag(:input, :type=>"text", :id => 'linkback_source_url')
  end
  it "should have a text field for inputting the type" do
    @body.should have_tag(:input, :type=>"text", :id => 'linkback_type')
  end
  it "should have a text_area field for inputting the excerpt" do
    @body.should have_tag(:textarea, :id => 'linkback_excerpt')
  end
end

