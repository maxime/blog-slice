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

  it "should have the title, content, rendered_content, rendering_type, status and timestamps properties" do
    properties_name = Post.properties.collect{|p| p.name}
    [ :title,
      :content, 
      :rendered_content, 
      :rendering_engine, 
      :published_at,
      :views_count, 
      :allow_comments,
      :allow_trackbacks,
      :status,
      :created_at, 
      :updated_at].each do |column|
      properties_name.should include(column)
    end
  end
  
  it "should have a slug property" do
    Post.properties.collect{|p| p.name}.should include(:slug)
  end
  
  it "should have a categories_ids= helper to mass-assign categories" do
    Category.all.destroy!
    information_technology = Category.create(:name => "Information Technology")
    chinese = Category.create(:name => 'Chinese')
    
    p = Post.create(  :title => "My new post",
                      :published_at => Time.now,
                      :content => "Hi!",
                      :categories_ids => [information_technology.id, chinese.id])
    p.categories.should have(2).things
    p.categories.should include(information_technology)
    p.categories.should include(chinese)
    
    p.categories_ids = [information_technology.id]
    
    p.reload
    
    p.categories.should have(1).thing
    p.categories.should include(information_technology)
    p.categories.should_not include(chinese)
  end
  
  it "should have a categories_ids helper to get the ids of the categories associated" do
    Category.all.destroy!
    information_technology = Category.create(:name => "Information Technology")
    chinese = Category.create(:name => 'Chinese')
    
    p = Post.create(  :title => "My new post",
                      :published_at => Time.now,
                      :content => "Hi!",
                      :categories_ids => [information_technology.id, chinese.id])

    p.categories_ids.should have(2).things
    p.categories_ids.should include(chinese.id)
    p.categories_ids.should include(information_technology.id)
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
  
  describe "status" do
    it "should have a status_name property to display a human readable status" do
      @post = Post.new(:status => 0)
      @post.status_name.should == "Published"
      
      @post.status = 1
      @post.status_name.should == "Draft"
      
      @post.status = 2
      @post.status_name.should == "Pending review"
    end
    
    it "should be published by default" do
      @post = Post.new
      @post.status_name.should == "Published"
    end
    
    it "should have draft? published? and pending_review? helpers" do
      @post = Post.new
      @post.should be_published
      @post.should_not be_pending_review
      @post.should_not be_draft
      
      @post.status = 1
      @post.should be_draft
      @post.should_not be_pending_review
      @post.should_not be_published
      
      @post.status = 2
      @post.should be_pending_review
      @post.should_not be_draft
      @post.should_not be_published
    end
  end
end

describe Post, "associations" do
  it "should belongs to many categories" do
    Post.relationships.should be_has_key(:categories)
    Post.relationships[:categories].parent_model.should == Post
    Post.relationships[:categories].child_model.should == CategoryPost
  end
  
  it "should have many linkbacks" do
    Post.relationships.should be_has_key(:linkbacks)
    Post.relationships[:linkbacks].parent_model.should == Post
    Post.relationships[:linkbacks].child_model.should == Linkback
  end
  
  it "should have many incoming_linkbacks" do
    Post.relationships.should be_has_key(:incoming_linkbacks)
    Post.relationships[:incoming_linkbacks].parent_model.should == Post
    Post.relationships[:incoming_linkbacks].child_model.should == Linkback
    
    @post = Post.create(:title => "Bla")
    Linkback.create(:source_url => 'ekohe.com', :type => 'trackback', :direction => true, :post_id => @post.id)
    @post.reload
    
    @post.linkbacks.should have(1).thing
    @post.incoming_linkbacks.should have(1).thing
    @post.outgoing_linkbacks.should be_empty
  end
    
  it "should have many outgoing_linkbacks" do
    Post.relationships.should be_has_key(:outgoing_linkbacks)
    Post.relationships[:outgoing_linkbacks].parent_model.should == Post
    Post.relationships[:outgoing_linkbacks].child_model.should == Linkback
  end
end

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