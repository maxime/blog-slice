require File.dirname(__FILE__) + '/../spec_helper'

include Merb::BlogSlice

describe TextRendering do
  before(:all) do
    class Article
      include DataMapper::Resource
      include Merb::BlogSlice::TextRendering
      
      property :id, Integer, :serial => true
      property :content, Text, :nullable => false
    end
  end 
  
  describe "rendering_class" do
    it "should be RedCloth by default" do
      Article.new.rendering_class.should == RedCloth
    end

    it "should be BlueCloth if the markdown rendering engine is specified" do
      Article.new(:rendering_engine => 'markdown').rendering_class.should == BlueCloth
    end
  end

  describe "rendering" do
    it "should render the content as textile by default" do
      article = Article.new(:content => "h1. Hello World!")
      article.valid?
      article.rendered_content.should == "<h1>Hello World!</h1>"
    end

    it "should render the content as markdown if specified" do
      article = Article.new(:content => "Hello World!\n====================", :rendering_engine => 'markdown')
      article.valid?
      article.rendered_content.should == "<h1>Hello World!</h1>"
    end
  end
end