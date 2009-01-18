require File.dirname(__FILE__) + '/../../spec_helper'

describe "linkbacks/index" do
  before :all do
    Merb::Router.prepare { |r| slice(:BlogSlice, :name_prefix => nil, :path_prefix => nil, :default_routes => false) } if standalone?
  end

  after :all do
    Merb::Router.reset! if standalone?
  end
  
  before(:each) do                    
    @controller = BlogSlice::Linkbacks.new(fake_request)
    
    @first_linkback = Linkback.new({:type=>"absciss", :target_url=>"gastrostaxis", :title=>"usually", :source_url=>"Cymodoceaceae", :excerpt=>"Incidence pasteurism reedish plumoseness gangan sanctity", :id=>0, :blog_name=>"costochondral"})
    @second_linkback = Linkback.new({:type=>"antipathize", :target_url=>"forthcut", :title=>"boattail", :source_url=>"pistillid", :excerpt=>"Dixit delegable missmark rhinobatus tallowmaking consilience hectocotylize foster ureic conjubilant pyroligneous paean prelumbar transdermic alicia driveboat coscinodiscaceae mockernut escortage", :id=>1, :blog_name=>"Orion"})
    
    @linkbacks = [@first_linkback, @second_linkback]
    
    @controller.instance_variable_set(:@linkbacks, @linkbacks)
    @body = @controller.render(:index) 
  end
  
  it "should display the BlogSlice::Linkbacks title" do
    @body.should have_tag(:h1) {|h1| h1.should contain("Linkbacks")}
  end
  
  it "should display the different linkbacks" do

    @body.should have_tag(:tr, :id => "linkback_#{@first_linkback.id}") {|tr| tr.should contain(@first_linkback.blog_name.to_s) }
    @body.should have_tag(:tr, :id => "linkback_#{@second_linkback.id}") {|tr| tr.should contain(@second_linkback.blog_name.to_s) }

    @body.should have_tag(:tr, :id => "linkback_#{@first_linkback.id}") {|tr| tr.should contain(@first_linkback.target_url.to_s) }
    @body.should have_tag(:tr, :id => "linkback_#{@second_linkback.id}") {|tr| tr.should contain(@second_linkback.target_url.to_s) }

    @body.should have_tag(:tr, :id => "linkback_#{@first_linkback.id}") {|tr| tr.should contain(@first_linkback.title.to_s) }
    @body.should have_tag(:tr, :id => "linkback_#{@second_linkback.id}") {|tr| tr.should contain(@second_linkback.title.to_s) }

    @body.should have_tag(:tr, :id => "linkback_#{@first_linkback.id}") {|tr| tr.should contain(@first_linkback.source_url.to_s) }
    @body.should have_tag(:tr, :id => "linkback_#{@second_linkback.id}") {|tr| tr.should contain(@second_linkback.source_url.to_s) }

    @body.should have_tag(:tr, :id => "linkback_#{@first_linkback.id}") {|tr| tr.should contain(@first_linkback.type.to_s) }
    @body.should have_tag(:tr, :id => "linkback_#{@second_linkback.id}") {|tr| tr.should contain(@second_linkback.type.to_s) }

    @body.should have_tag(:tr, :id => "linkback_#{@first_linkback.id}") {|tr| tr.should contain(@first_linkback.excerpt.to_s) }
    @body.should have_tag(:tr, :id => "linkback_#{@second_linkback.id}") {|tr| tr.should contain(@second_linkback.excerpt.to_s) }
  end
end

describe "linkbacks/index, post as parent" do
  before :all do
    Merb::Router.prepare { |r| slice(:BlogSlice, :name_prefix => nil, :path_prefix => nil, :default_routes => false) } if standalone?
  end

  after :all do
    Merb::Router.reset! if standalone?
  end
  
  before(:each) do                    
    @controller = BlogSlice::Linkbacks.new(fake_request)
    
    @post = Post.new(:slug => 'my-first-blog-post')
    @controller.instance_variable_set(:@post, @post)
    
    @first_linkback = Linkback.new({:type=>"sylvanitic", :target_url=>"unharmonize", :title=>"misalienate", :source_url=>"tane", :excerpt=>"Disconcertment crumblet mineralizable loris plutonian precool amphicoelous brotheler loxodromism ice benzine chieftainship sporadic shikimic commutate embryonically", :id=>1, :blog_name=>"relieved"})
    @first_linkback.stub!(:post).and_return(@post)
    @second_linkback = Linkback.new({:type=>"glimmerous", :target_url=>"heterogony", :title=>"precedentless", :source_url=>"fomes", :excerpt=>"Gormandize vaticanic ooecial blattiform narratory bepart shelleyana mercaptids transpalmar anticontagionist microphthalmus unseparable internode", :id=>4, :blog_name=>"Megaric"})
    @second_linkback.stub!(:post).and_return(@post)
    
    @linkbacks = [@first_linkback, @second_linkback]
    
    @controller.instance_variable_set(:@linkbacks, @linkbacks)
    @body = @controller.render(:index) 
  end
  
  it "should display the BlogSlice::Linkbacks and Posts title" do
    @body.should have_tag(:h1) {|h1| h1.should contain("Posts")}    
    @body.should have_tag(:h1) {|h1| h1.should contain("Linkbacks")}
  end
  
  it "should display the different linkbacks" do

    @body.should have_tag(:tr, :id => "linkback_#{@first_linkback.id}") {|tr| tr.should contain(@first_linkback.blog_name.to_s) }
    @body.should have_tag(:tr, :id => "linkback_#{@second_linkback.id}") {|tr| tr.should contain(@second_linkback.blog_name.to_s) }

    @body.should have_tag(:tr, :id => "linkback_#{@first_linkback.id}") {|tr| tr.should contain(@first_linkback.target_url.to_s) }
    @body.should have_tag(:tr, :id => "linkback_#{@second_linkback.id}") {|tr| tr.should contain(@second_linkback.target_url.to_s) }

    @body.should have_tag(:tr, :id => "linkback_#{@first_linkback.id}") {|tr| tr.should contain(@first_linkback.title.to_s) }
    @body.should have_tag(:tr, :id => "linkback_#{@second_linkback.id}") {|tr| tr.should contain(@second_linkback.title.to_s) }

    @body.should have_tag(:tr, :id => "linkback_#{@first_linkback.id}") {|tr| tr.should contain(@first_linkback.source_url.to_s) }
    @body.should have_tag(:tr, :id => "linkback_#{@second_linkback.id}") {|tr| tr.should contain(@second_linkback.source_url.to_s) }

    @body.should have_tag(:tr, :id => "linkback_#{@first_linkback.id}") {|tr| tr.should contain(@first_linkback.type.to_s) }
    @body.should have_tag(:tr, :id => "linkback_#{@second_linkback.id}") {|tr| tr.should contain(@second_linkback.type.to_s) }

    @body.should have_tag(:tr, :id => "linkback_#{@first_linkback.id}") {|tr| tr.should contain(@first_linkback.excerpt.to_s) }
    @body.should have_tag(:tr, :id => "linkback_#{@second_linkback.id}") {|tr| tr.should contain(@second_linkback.excerpt.to_s) }
  end
end

