require File.dirname(__FILE__) + '/../../spec_helper'

describe "linkbacks/show" do
  before :all do
    Merb::Router.prepare { |r| slice(:BlogSlice, :name_prefix => nil, :path_prefix => nil, :default_routes => false) } if standalone?
  end

  after :all do
    Merb::Router.reset! if standalone?
  end
  
  before(:each) do                    
    @controller = BlogSlice::Linkbacks.new(fake_request)
    @linkback = Linkback.new({:type=>"goldlike", :target_url=>"hypercarnal", :title=>"algodoncillo", :source_url=>"quercinic", :excerpt=>"Epibenthos astrometeorological hematitic neoza servetianism", :id=>4, :blog_name=>"Diatoma"})
    
    @controller.instance_variable_set(:@linkback, @linkback)
    @body = @controller.render(:show) 
  end
  
  it "should display the title" do
    @body.should have_tag(:h1) {|h1| h1.should contain("Linkbacks")}
  end

  it "should display the blog_name" do
    @body.should have_tag(:p, :id => "blog_name") {|p| p.should contain(@linkback.blog_name.to_s)}
  end
  it "should display the target_url" do
    @body.should have_tag(:p, :id => "target_url") {|p| p.should contain(@linkback.target_url.to_s)}
  end
  it "should display the title" do
    @body.should have_tag(:p, :id => "title") {|p| p.should contain(@linkback.title.to_s)}
  end
  it "should display the source_url" do
    @body.should have_tag(:p, :id => "source_url") {|p| p.should contain(@linkback.source_url.to_s)}
  end
  it "should display the type" do
    @body.should have_tag(:p, :id => "type") {|p| p.should contain(@linkback.type.to_s)}
  end
  it "should display the excerpt" do
    @body.should have_tag(:p, :id => "excerpt") {|p| p.should contain(@linkback.excerpt.to_s)}
  end
end

describe "linkbacks/show, post as parent" do
  before :all do
    Merb::Router.prepare { |r| slice(:BlogSlice, :name_prefix => nil, :path_prefix => nil, :default_routes => false) } if standalone?
  end

  after :all do
    Merb::Router.reset! if standalone?
  end
  
  before(:each) do                    
    @controller = BlogSlice::Linkbacks.new(fake_request)
    @post = Post.new(:slug => 1)
    @linkback = Linkback.new({:type=>"microsecond", :target_url=>"Merycopotamidae", :title=>"unequalized", :source_url=>"demichamfron", :excerpt=>"Pelicometer gaw aleutite hallmark sibyl symbiot gnarliness nejdi lepanto somnifuge", :id=>2, :blog_name=>"melanterite"})
    @linkback.stub!(:post).and_return(@post)
    
    @controller.instance_variable_set(:@linkback, @linkback)
    @controller.instance_variable_set(:@post, @post)
    
    @body = @controller.render(:show) 
  end
  
  it "should display the title" do
    @body.should have_tag(:h1) {|h1| h1.should contain("Post")}
    @body.should have_tag(:h1) {|h1| h1.should contain("Linkbacks")}
  end

  it "should display the blog_name" do
    @body.should have_tag(:p, :id => "blog_name") {|p| p.should contain(@linkback.blog_name.to_s)}
  end
  it "should display the target_url" do
    @body.should have_tag(:p, :id => "target_url") {|p| p.should contain(@linkback.target_url.to_s)}
  end
  it "should display the title" do
    @body.should have_tag(:p, :id => "title") {|p| p.should contain(@linkback.title.to_s)}
  end
  it "should display the source_url" do
    @body.should have_tag(:p, :id => "source_url") {|p| p.should contain(@linkback.source_url.to_s)}
  end
  it "should display the type" do
    @body.should have_tag(:p, :id => "type") {|p| p.should contain(@linkback.type.to_s)}
  end
  it "should display the excerpt" do
    @body.should have_tag(:p, :id => "excerpt") {|p| p.should contain(@linkback.excerpt.to_s)}
  end
end

