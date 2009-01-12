class Comment
  include DataMapper::Resource
  include DataMapper::Timestamp
  include Merb::BlogSlice::TextRendering
    
  property :id, Integer, :serial => true
  property :author, String
  property :email, String
  property :url, String
  property :content, Text
  
  property :approved, Boolean # comment moderation
  
  property :ip_address, String

  property :created_at, Time
  property :updated_at, Time  
  
  belongs_to :post
  
  # Validations
  validates_present :author, :message => "Name is required"
  validates_present :email, :message => "Mail is required"
  validates_format :email, :as => :email_address, :message => "Mail is invalid", :if => lambda {|o| o.email && !o.email.empty? }
  validates_present :content, :message => "Comment is required"
end