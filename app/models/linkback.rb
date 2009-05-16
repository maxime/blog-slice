require 'hpricot'
require 'open-uri'

class Linkback
  include DataMapper::Resource
  include DataMapper::Timestamp
  
  property :id, Serial
  property :blog_name, String
  property :target_url, String
  property :title, String
  property :source_url, String, :nullable => false
  property :type, String, :nullable => false
  property :excerpt, Text
  property :approved, Boolean, :default => false
  
  property :direction, Boolean, :default => true # true is incoming, false is outgoing
  
  property :created_at, Time
  property :updated_at, Time
  
  belongs_to :post
  
  def incoming?
    self.direction == true
  end

  def outgoing?
    self.direction == true
  end
  
  def handle_linkback
    begin
      #source_html = open(source_uri) if source_uri =~ /^http:\/\//
      #@parser     = Hpricot(source_html)

      self.title  = "bla" # FIXME
      #return 17 unless @linking_node = find_linking_node_to(target_uri)
      #@excerpt = excerpt_content_to(@linking_node, target_uri)
      self.excerpt = "bla" # FIXME
      self.save
      #return 33 unless save_pingback # invoke the outside callback.
      return "Ping from #{source_uri} to #{target_uri} registered. Thanks for linking to us."
      ### TODO: let save_callback propagate other error codes.

    rescue SocketError, OpenURI::HTTPError => e
      return 16
    end
  end
end