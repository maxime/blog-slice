require File.dirname(__FILE__) + '/../spec_helper'

describe Linkback do
  before :each do
    @linkback = Linkback.new
  end
  
  it "should have the blog_name, target_url, title, source_url, type, excerpt columns" do
    [:blog_name, :target_url, :title, :source_url, :type, :excerpt, :approved, :direction].each do |column|
      @linkback.attributes.keys.should include(column)
    end
  end

  it "should have a belongs_to association with Post" do
    Linkback.relationships.should be_has_key(:post)
    Linkback.relationships[:post].parent_model.should == Post
  end
  
  it "should not be approved by default" do
    @linkback.approved.should == false
  end
  
  it "should be incoming by default" do
    @linkback.should be_incoming
  end
end

describe Linkback, 'validations' do
  before :each do
    @linkback = Linkback.new(:type => 'trackback', :source_url => 'ekohe.com', :approved => false)
  end
  
  it "should be valid" do
    @linkback.should be_valid
  end
  
  it "should require the type presence" do
    @linkback.type = nil
    @linkback.should_not be_valid
    @linkback.errors.on(:type).should include("Type must not be blank")
    @linkback.type = 'pingback'
  end
  
  it "should require the source_url presence" do
    @linkback.source_url = nil
    @linkback.should_not be_valid
    @linkback.errors.on(:source_url).should include("Source url must not be blank")
    @linkback.source_url = 'ekohe.com'
  end
end