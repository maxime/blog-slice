xml.instruct! :xml, :version => "1.0" 
xml.rss :version => "2.0", 'xmlns:atom' => "http://www.w3.org/2005/Atom" do |rss|
  rss.channel do |channel|
    rss.title       blog_options[:feed_title]        if blog_options[:feed_title]
    rss.link        blog_options[:feed_link]         if blog_options[:feed_link]
    rss.description blog_options[:feed_description]  if blog_options[:feed_description]
    rss.language    blog_options[:feed_language]     if blog_options[:feed_language]
    rss.atom(:link, :href => (blog_options[:host] + blog_options[:feed_url]), :rel => "self", :type => "application/rss+xml")
    
    @posts.each do |post|
      channel.item do |item|
        item.title post.title
        item.description do |description|
          description.cdata!(post.rendered_content)
        end
        item.pubDate post.created_at.utc.rfc822
        item.link(blog_options[:host] + url(:blog_slice_post, :id => post.slug))
        item.guid(blog_options[:host] + url(:blog_slice_post, :id => post.slug))
      end
    end
  end
end