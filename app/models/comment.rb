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
  
  # Form definition for simple forms
  def self.form_definition
    {:attributes => [ {:author =>             {:control => :text_field}},
                      {:url =>                {:control => :text_field}},
                      {:email =>              {:control => :text_field}},
                      {:content =>            {:control => :text_area}}],
     :nested_within => 'posts',
     :slice => true,
     :cancel_url => false}
  end
end