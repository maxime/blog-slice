class Linkback
  include DataMapper::Resource
  
  property :id, Serial
  property :blog_name, String
  property :target_url, String
  property :title, String
  property :source_url, String, :nullable => false
  property :type, String, :nullable => false
  property :excerpt, Text
  property :approved, Boolean, :default => false
  
  property :direction, Boolean, :default => true # true is incoming, false is outgoing
  
  belongs_to :post
  
  def incoming?
    self.direction == true
  end

  def outgoing?
    self.direction == true
  end
end