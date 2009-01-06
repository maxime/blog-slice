require File.dirname(__FILE__) + '/../spec_helper'

describe Post do
  it "should require a title" do
    p = Post.new
    p.should_not be_valid
    p.title = "My First Blog Post"
    p.should be_valid
  end
  
  it "should use textile as default rendering engine" do
    p = Post.create(:title => "My new post")
    p.rendering_engine.should == 'textile'
  end

  it "should have the title, content, rendered_content, rendering_type and timestamps properties" do
    properties_name = Post.properties.collect{|p| p.name}
    [:title, :content, :rendered_content, :rendering_engine, :created_at, :updated_at].each do |column|
      properties_name.should include(column)
    end
  end
  
  it "should have a slug property" do
    Post.properties.collect{|p| p.name}.should include(:slug)
  end
  
  describe "comments" do
    before do
      @post = Post.create(:title => 'My First Blog Post')
    end
    
    def create_comment
      @post.comments.create(:author => "Maxime Guilbot", :email => "some@email.com", :content => "Here is my comment")      
    end
    
    it "should be an empty array if there are no comments yet" do
      @post.comments.should be_empty
    end
    
    it "should allow the creation of comments" do
      # Create a comment
      comment = create_comment
      
      # Check if the post is in the comments array of the post
      @post.comments.should include(comment)
      @post.comments.size.should == 1
    end
    
    it "should allow the deletion of comments" do
      # Create a comment
      comment = create_comment
      
      # Check the presence of the comment in the post comments array
      @post.comments.should include(comment)
      @post.comments.size.should == 1
      
      # Destroy the comment
      comment.destroy
      
      # Reload the post and check if the comment really disappeared
      @post.reload
      @post.comments.should be_empty
    end
  end
end

# This spec should be here but should be in dm-is-taggable.
# As dm-is-taggable very new, I prefer to make sure that everything is working as expected
describe Post, "tagging" do
  before(:each) do
    Post.auto_migrate!
    @post = Post.create(:title => "My First Post")
  end
  
  def tags
    ["welcome", "technology", "english"]
  end
  
  def do_tag
    @post.tag(tags)
  end
  
  it "should allow tagging a post" do
    do_tag
    # Check if the post is tagged with 3 tags
    @post.tags.should have(3).things
    # Check if it's really the same tags
    tags.each {|t| @post.tags.should include(Tag.build(t)) }
  end
  
  it "should be able to find the post with the tags" do
    do_tag
    tags.each do |t|
      Post.tagged_with(t).should have(1).thing
      Post.tagged_with(t).should include(@post)
    end
  end
  
  it "should be able to get the tags_list" do
    do_tag
    @post.tags_list.should include("welcome")
    @post.tags_list.should include("technology")
    @post.tags_list.should include("english")
  end
  
  it "should be able to tag with the tags_list property" do
    @post = Post.new(:title => "My First Post", :tags_list => "welcome, technology, english")
    @post.save
    
    # Check if the post is tagged with 3 tags
    @post.tags.reload
    @post.tags.should have(3).things
    # Check if it's really the same tags
    tags.each {|t| @post.tags.should include(Tag.build(t)) }
    
    @post.tags_list = "french, spanish"
    @post.tags.reload
    # Check if the post is tagged with 2 tags
    @post.tags.should have(2).things
    
    # Check if it's really the same tags
    @post.tags.should include(Tag.build('french'))   
    @post.tags.should include(Tag.build('spanish'))   
  end
end