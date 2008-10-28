require File.join(File.dirname(__FILE__), "../..", 'spec_helper.rb')

describe "posts/form" do 
  before :all do
    Merb::Router.prepare { |r| slice(:BlogSlice, :name_prefix => nil, :path_prefix => nil, :default_routes => false) } if standalone?
  end

  after :all do
    Merb::Router.reset! if standalone?
  end
  
  before :each do                    
    @controller = BlogSlice::Posts.new(fake_request)
    post = Post.new(:title => 'My First Post', :rendered_content => '<b>This is my first post</b>')
    @controller.instance_variable_set(:@post, post) 
    @body = @controller.render(:form)
  end
  
  it "should render a form for creating the post" do
    @body.should have_tag(:form, :action => '/posts', :method => 'post')
  end
  
  it "should have a text field for the title" do
    @body.should have_tag(:input, :type => :text, :id => 'post_title')
  end
  
  it "should have a text area for the content" do
    @body.should have_tag(:textarea, :id => 'post_content')
  end
  
  it "should have a select for selecting the rendering engine" do
    @body.should have_tag(:select, :id => 'post_rendering_engine')
  end
  
  it "should have a tag text field for the tags" do
    @body.should have_tag(:input, :type => :text, :id => 'post_tags_list')
  end
end