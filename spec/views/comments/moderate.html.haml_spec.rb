require File.join(File.dirname(__FILE__), "../..", 'spec_helper.rb')

describe "comments/moderate" do 
  before :all do
    Merb::Router.prepare { |r| slice(:BlogSlice, :name_prefix => nil, :path_prefix => nil, :default_routes => false) } if standalone?
  end

  after :all do
    Merb::Router.reset! if standalone?
  end
  
  
  def sample_comments
    first_comment = Comment.new(:id => 1, :author => "Maxime Guilbot",
                                :url => "http://www.ekohe.com",
                                :rendered_content => 'Very nice blog!',
                                :approved => false,
                                :created_at => Time.now)
    first_comment.stub!(:post).and_return(@post)
    
    second_comment = Comment.new(:id => 2, :author => "James Antony",
                                :url => "http://www.ekohe.com",
                                :approved => false,
                                :rendered_content => 'Very beautiful blog!',
                                :created_at => Time.now)
    second_comment.stub!(:post).and_return(@post)
    
    [first_comment, second_comment]
  end
  
  before(:each) do                    
    @controller = BlogSlice::Comments.new(fake_request)
    @post = Post.new(:slug => "bla")
    @controller.stub!(:params).and_return({:action => 'moderate'})
    @controller.instance_variable_set(:@comments, sample_comments) 
    @body = @controller.render(:moderate)
  end
  
  it "should display the title" do
    @body.should have_tag(:h1) {|h1| h1.should contain("Comments Moderation")}
  end
  
  it "should display the comments" do
    @body.should contain("Very nice blog!")
    @body.should contain("Very beautiful blog!")    
  end
  
  it "should have buttons to approve the comments" do
    @body.should have_tag(:a, :href => '/posts/bla/comments/1/approve')
    @body.should have_tag(:a, :href => '/posts/bla/comments/2/approve')
  end
end