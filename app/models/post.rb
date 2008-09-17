class Post
  include DataMapper::Resource
  include DataMapper::Timestamp
  include Merb::BlogSlice::TextRendering
  
  property :id, Integer, :serial => true
  property :title, String, :nullable => false
  property :content, Text # Formatted text
  
  property :created_at, Time
  property :updated_at, Time
  
  has n, :comments
  
  is :slug, :source => :title
  
  is :taggable, :by => []
  
  # Form definition for simple forms
  def self.form_definition
    {:attributes => [ {:title =>              {:control => :text_field}}, 
                      {:content =>            {:control => :text_area}},
                      {:rendering_engine =>   {:control => :select, :collection => Post.rendering_engines}},
                      {:taglist =>            {:control => :text_field, :label => 'Tags'}}]}
  end
  
  # Extra tagging functionalities
  
  after :save, :tag_now_with_taglist
  
  def taglist
    @taglist || TagList.new(self.tags.collect{|t| t.name}).to_s
  end
  
  def taglist=(ataglist)
    # if the object is a new record, we will tag the object after save
    # if the object isn't a new record, we tag the object now
    @taglist = ataglist
    tag_now_with_taglist unless new_record?
    true
  end
  
  def tag_now_with_taglist
    return unless @taglist 
    # Destroy all the taggings
    self.taggings.destroy! unless self.new_record?

    # Tag with the tag list
    self.tag(:with => TagList.from(@taglist))
    @taglist = nil   
  end
end