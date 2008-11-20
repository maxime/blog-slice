class Tag
  is :slug, :source => :name
  
  # This is used for the tag cloud
  # size is a number from 0 to 7, providing 8 different sizes
  # you can change the formula here to get different clouds
  def size
    s = (self.posts.size.to_f / 2.0).ceil
    s = 8 if s > 8
    s
  end
end