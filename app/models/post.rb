class Post
  include DataMapper::Resource
  include DataMapper::Timestamp
  include Merb::BlogSlice::TextRendering
  
  property :id, Integer, :serial => true
  property :title, String, :nullable => false
  property :content, Text
  
  property :published_at, Time
  property :views_count, Integer, :default => 0

  property :allow_comments, Boolean, :default => true
  property :allow_trackbacks, Boolean, :default => true

  property :created_at, Time
  property :updated_at, Time
  
  has n, :comments, :approved => true, :order => [:created_at.desc]
  
  is :slug, :source => :title
  is :taggable
  
  has n, :categories, :through => Resource
  
  def categories_ids=(ids)
    new_categories = ids.collect{ |id| Category.get(id)}
    
    # Adding new categories
    new_categories.each do |category|
      self.categories << category if category and !self.categories.include?(category)
    end
    
    # Removing the old ones
    self.categories.each do |category|
      unless new_categories.include?(category)
        join = CategoryPost.first(:category_id => category.id, :post_id => self.id)
        join.destroy unless join.nil?
      end
    end
  end

  def categories_ids
    self.categories.collect{|category| category.id}
  end
  
  def self.per_page
    10
  end
end