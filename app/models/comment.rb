class Comment
  include DataMapper::Resource
  include DataMapper::Timestamp
  include Merb::BlogSlice::TextRendering
    
  property :id, Integer, :serial => true
  property :author, String, :nullable => false
  property :email, String, :nullable => false
  property :url, String
  property :content, Text, :nullable => false
  
  property :created_at, Time
  property :updated_at, Time
  
  belongs_to :post
end