require File.join(File.dirname(__FILE__), "../..", 'spec_helper.rb')

describe "posts/index" do 
  before :all do
    Merb::Router.prepare { |r| r.add_slice(:BlogSlice) } if standalone?
  end

  after :all do
    Merb::Router.reset! if standalone?
  end
  
  before(:each) do                    
    @controller = BlogSlice::Posts.new(fake_request) 
    first_post = mock('first_post')
    first_post.stub!(:id).and_return(1)
    first_post.stub!(:title).and_return("My First Post")
    first_post.stub!(:rendered_content).and_return("<b>This is my first post</b>")
    second_post = mock('second_post')
    second_post.stub!(:id).and_return(2)
    second_post.stub!(:title).and_return("My Second Post")
    second_post.stub!(:rendered_content).and_return("<strong>This is the second post of my blog</strong>")
    @controller.instance_variable_set(:@posts, [first_post, second_post]) 
    @body = @controller.render(:index) 
  end 
 
  it "should display the posts list" do
    @body.should have_tag(:div, :id => 'post_1')
    @body.should have_tag(:div, :id => 'post_2')
  end
 
  it "should display the posts titles" do
    @body.should have_tag(:div, :id => 'post_1').with_tag(:h2) {|h2| h2.should contain("My First Post")}
    @body.should have_tag(:div, :id => 'post_2').with_tag(:h2) {|h2| h2.should contain("My Second Post")}
  end

 it "should display the posts rendered content" do
   @body.should have_tag(:div, :id => 'post_1').with_tag(:div, :class => "content") {|div| div.should contain("<b>This is my first post</b>")}
   @body.should have_tag(:div, :id => 'post_2').with_tag(:div, :class => "content") {|div| div.should contain("<strong>This is the second post of my blog</strong>")}
 end  
 
 it "should have a link for creating a new post" do
   @body.should have_tag(:a, :href => url(:new_blog_slice_posts))
 end
end