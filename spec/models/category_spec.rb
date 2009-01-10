require File.dirname(__FILE__) + '/../spec_helper'

describe Category do
  before :each do
    Category.all.destroy!
    @category = Category.new
  end
  
  it "should have the name columns" do
    [:name].each do |column|
      @category.attributes.keys.should include(column)
    end
  end
  
  it "should have a slug" do
    @category = Category.new(:name => "Information Technology")
    @category.save
    @category.slug.should == "information-technology"
  end
end

describe Category, 'validations' do
  before :each do
    Category.all.destroy!
    @category = Category.new(:name => "Technology")
  end
  
  it "should be valid" do
    @category.should be_valid
  end
  
  it "should require the name presence" do
    @category.name = nil
    @category.should_not be_valid
    @category.errors.on(:name).should include("Name must not be blank")
  end
  
  it "should require the name uniqueness" do
    @category.save
    
    duplicate = Category.new(:name => "Technology")
    
    duplicate.should_not be_valid
    duplicate.errors.on(:name).should include("Name is already taken")
  end
end

describe Category, "associations" do
  it "should have many posts" do
    Category.relationships.should be_has_key(:posts)
    Category.relationships[:posts].parent_model.should == Category
    Category.relationships[:posts].child_model.should == CategoryPost
  end
end
