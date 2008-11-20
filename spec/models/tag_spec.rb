require File.dirname(__FILE__) + '/../spec_helper'

describe Tag do
  it "should have a slug property" do
    Tag.new.attributes.keys.should include(:slug)
  end
  
  it "should have a slug to identify the tag" do
    chocolate = Tag.create(:name => "Chocolate")
    chocolate.slug.should == 'chocolate'
    
    nyc = Tag.create(:name => "New York City")
    nyc.slug.should == 'new-york-city'
    
    nyc2 = Tag.create(:name => "New york City")
    nyc2.slug.should == 'new-york-city-2'    
  end
end