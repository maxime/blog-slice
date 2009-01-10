require File.join(File.dirname(__FILE__), "../..", 'spec_helper.rb')

describe "comments/form" do 
  before :all do
    Merb::Router.prepare { |r| slice(:BlogSlice, :name_prefix => nil, :path_prefix => nil, :default_routes => false) } if standalone?
  end

  after :all do
    Merb::Router.reset! if standalone?
  end
  
  before :each do                    
    @controller = BlogSlice::Comments.new(fake_request)
    @post = Post.new(:title => 'My First Post', :rendered_content => '<b>This is my first post</b>', :slug => 'my-first-post')
    @controller.instance_variable_set(:@post, @post) 
    comment = Comment.new(:author => "Maxime Guilbot")
    @controller.instance_variable_set(:@comment, comment) 
    @body = @controller.render(:form)
  end
  
  it "should render a form for creating the post" do
    @body.should have_tag(:form, :action => '/posts/my-first-post/comments', :method => 'post')
  end
  
  it "should have a text field for the author" do
    @body.should have_tag(:input, :type => :text, :name => 'comment[author]')
  end
  
  it "should have a text field for the url" do
    @body.should have_tag(:input, :type => :text, :name => 'comment[url]')
  end
  
  it "should have a text field for the email" do
    @body.should have_tag(:input, :type => :text, :name => 'comment[email]')
  end
  
  it "should have a text area for the content" do
    @body.should have_tag(:textarea, :name => 'comment[content]')
  end
end