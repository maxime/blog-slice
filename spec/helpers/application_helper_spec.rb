require File.dirname(__FILE__) + '/../spec_helper'

include Merb::BlogSlice
include Merb::BlogSlice::ApplicationHelper

describe ApplicationHelper, "image_path('image.jpg')" do
  it "should be /slices/blog-slice/images/image.jpg" do
    image_path('image.jpg').should == '/slices/blog-slice/images/image.jpg'
  end
end

describe ApplicationHelper, "javascript_path('application.js')" do
  it "should be /slices/blog-slice/javascripts/application.js" do
    javascript_path('application.js').should == '/slices/blog-slice/javascripts/application.js'
  end
end

describe ApplicationHelper, "stylesheet_path('application.css')" do
  it "should be /slices/blog-slice/stylesheets/application.css" do
    stylesheet_path('application.css').should == '/slices/blog-slice/stylesheets/application.css'
  end
end

describe ApplicationHelper, "public_path_for(:something, 'file')" do
  it "should be /slices/blog-slice/something/file" do
    public_path_for(:image, 'file').should == '/slices/blog-slice/images/file'
  end
end

describe ApplicationHelper, "app_path_for(:something, 'file')" do
  it "should be /slices/blog-slice/something/file" do
    app_path_for(:image, 'file').should == File.expand_path(File.join(File.dirname(__FILE__), '/../../public/slices/blog-slice/images/file'))
  end
end

describe ApplicationHelper, "slice_path_for(:something, 'file')" do
  it "should be /slices/blog-slice/something/file" do
    slice_path_for(:image, 'file').should == File.expand_path(File.join(File.dirname(__FILE__), '/../../public/images/file'))
  end
end