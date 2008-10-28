require File.dirname(__FILE__) + '/spec_helper'

describe "BlogSlice (module)" do  
  # Feel free to remove the specs below
  
  before :all do
    Merb::Router.prepare { |r| slice(:BlogSlice, :name_prefix => nil, :path_prefix => nil, :default_routes => false) } if standalone?
  end
  
  after :all do
    Merb::Router.reset! if standalone?
  end
  
  it "should be registered in Merb::Slices.slices" do
    Merb::Slices.slices.should include(BlogSlice)
  end
  
  it "should be registered in Merb::Slices.paths" do
    Merb::Slices.paths[BlogSlice.name].should == current_slice_root
  end
  
  it "should have an :identifier property" do
    BlogSlice.identifier.should == "blog-slice"
  end
  
  it "should have an :identifier_sym property" do
    BlogSlice.identifier_sym.should == :blog_slice
  end
  
  it "should have a :root property" do
    BlogSlice.root.should == Merb::Slices.paths[BlogSlice.name]
    BlogSlice.root_path('app').should == current_slice_root / 'app'
  end
  
  it "should have a :file property" do
    BlogSlice.file.should == current_slice_root / 'lib' / 'blog-slice.rb'
  end
  
  it "should have metadata properties" do
    BlogSlice.description.should == "Blog Slice is a very basic blogging system"
    BlogSlice.version.should == "0.0.1"
    BlogSlice.author.should == "Maxime Guilbot for Ekohe"
  end
  
  it "should have :named_routes property" do
    BlogSlice.named_routes.should_not be_empty
    BlogSlice.named_routes[:posts].should be_kind_of(Merb::Router::Route)
  end
  
  it "should have a config property (Hash)" do
    BlogSlice.config.should be_kind_of(Hash)
  end
  
  it "should have bracket accessors as shortcuts to the config" do
    BlogSlice[:foo] = 'bar'
    BlogSlice[:foo].should == 'bar'
    BlogSlice[:foo].should == BlogSlice.config[:foo]
  end
  
  it "should have a :layout config option set" do
    BlogSlice.config[:layout].should == :blog_slice
  end
  
  it "should have a dir_for method" do
    app_path = BlogSlice.dir_for(:application)
    app_path.should == current_slice_root / 'app'
    [:view, :model, :controller, :helper, :mailer, :part].each do |type|
      BlogSlice.dir_for(type).should == app_path / "#{type}s"
    end
    public_path = BlogSlice.dir_for(:public)
    public_path.should == current_slice_root / 'public'
    [:stylesheet, :javascript, :image].each do |type|
      BlogSlice.dir_for(type).should == public_path / "#{type}s"
    end
  end
  
  it "should have a app_dir_for method" do
    root_path = BlogSlice.app_dir_for(:root)
    root_path.should == Merb.root / 'slices' / 'blog-slice'
    app_path = BlogSlice.app_dir_for(:application)
    app_path.should == root_path / 'app'
    [:view, :model, :controller, :helper, :mailer, :part].each do |type|
      BlogSlice.app_dir_for(type).should == app_path / "#{type}s"
    end
    public_path = BlogSlice.app_dir_for(:public)
    public_path.should == Merb.dir_for(:public) / 'slices' / 'blog-slice'
    [:stylesheet, :javascript, :image].each do |type|
      BlogSlice.app_dir_for(type).should == public_path / "#{type}s"
    end
  end
  
  it "should have a public_dir_for method" do
    public_path = BlogSlice.public_dir_for(:public)
    public_path.should == '/slices' / 'blog-slice'
    [:stylesheet, :javascript, :image].each do |type|
      BlogSlice.public_dir_for(type).should == public_path / "#{type}s"
    end
  end
  
  it "should have a public_path_for method" do
    public_path = BlogSlice.public_dir_for(:public)
    BlogSlice.public_path_for("path", "to", "file").should == public_path / "path" / "to" / "file"
    [:stylesheet, :javascript, :image].each do |type|
      BlogSlice.public_path_for(type, "path", "to", "file").should == public_path / "#{type}s" / "path" / "to" / "file"
    end
  end
  
  it "should have a app_path_for method" do
    BlogSlice.app_path_for("path", "to", "file").should == BlogSlice.app_dir_for(:root) / "path" / "to" / "file"
    BlogSlice.app_path_for(:controller, "path", "to", "file").should == BlogSlice.app_dir_for(:controller) / "path" / "to" / "file"
  end
  
  it "should have a slice_path_for method" do
    BlogSlice.slice_path_for("path", "to", "file").should == BlogSlice.dir_for(:root) / "path" / "to" / "file"
    BlogSlice.slice_path_for(:controller, "path", "to", "file").should == BlogSlice.dir_for(:controller) / "path" / "to" / "file"
  end
  
  it "should keep a list of path component types to use when copying files" do
    (BlogSlice.mirrored_components & BlogSlice.slice_paths.keys).length.should == BlogSlice.mirrored_components.length
  end
  
end