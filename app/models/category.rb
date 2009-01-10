class Category
  include DataMapper::Resource
  
  property :id, Serial
  property :name, String, :nullable => false, :unique => true
  
  is :slug, :source => :name
  
  has n, :posts, :through => Resource
end