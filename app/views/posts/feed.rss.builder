xml.instruct! :xml, :version => "1.0" 
xml.rss :version => "2.0", 'xmlns:atom' => "http://www.w3.org/2005/Atom" do |rss|
  rss.channel do |channel|
    rss.title       feed_options[:title]        if feed_options[:title]
    rss.link        feed_options[:link]         if feed_options[:link]
    rss.description feed_options[:description]  if feed_options[:description]
    rss.language    feed_options[:language]     if feed_options[:language]
    rss.atom(:link, :href => (feed_options[:host] + feed_options[:feed_url]), :rel => "self", :type => "application/rss+xml")
    
    @posts.each do |post|
      channel.item do |item|
        item.title post.title
        item.description do |description|
          description.cdata!(post.rendered_content)
        end
        item.pubDate post.created_at.utc.rfc822
        item.link(feed_options[:host] + url(:blog_slice_post, :id => post.slug))
        item.guid(feed_options[:host] + url(:blog_slice_post, :id => post.slug))
      end
    end
  end
end