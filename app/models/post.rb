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
                      {:tags_list =>          {:control => :text_field, :label => 'Tags'}}],
     :slice => true}
  end
end