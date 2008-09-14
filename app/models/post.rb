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
end