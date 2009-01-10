require File.dirname(__FILE__) + '/../spec_helper'

describe Comment do
  describe 'properties' do
    it "should have the name, email, url, content and timestamps properties" do
      properties_name = Comment.properties.collect{|p| p.name}
      [:author, :email, :url, :content, :rendered_content, :rendering_engine, :created_at, :updated_at].each do |column|
        properties_name.should include(column)
      end
    end
  end

  describe 'validations' do
    before do
      @comment = Comment.new(valid_attributes)
    end
    
    def valid_attributes
      {:author => "Maxime Guilbot", :email => "some@email.com", :content => "Hello!"}
    end
    
    it "should be valid" do
      @comment.should be_valid
    end
    
    it "should require the author name" do
      @comment.author = nil
      @comment.should_not be_valid
      @comment.errors.on(:author).should include("Name is required")
    end
    
    it "should require the email address" do
      @comment.email = ''
      @comment.should_not be_valid
      @comment.errors.on(:email).should include("Mail is required")
      @comment.errors.on(:email).should_not include("Mail is invalid")
    end
    
    it "should require a valid email address" do
      @comment.email = 'bla'
      @comment.should_not be_valid
      @comment.errors.on(:email).should include("Mail is invalid")
    end
    
    it "should require the comment content" do
      @comment.content = nil
      @comment.should_not be_valid
      @comment.errors.on(:content).should include("Comment is required")
    end
  end
  
  describe 'association with post' do
    before do
      @post = Post.create(:title => "My new post", :content => "Hi! Here is my new post")
    end
    
    it "should be able to associate with a post" do
      @comment = @post.comments.create(:author => 'Maxime Guilbot', :email => "some@email.com", :content => "Nice post.")
      @comment.save
      @comment.post.should == @post
    end
  end
end
