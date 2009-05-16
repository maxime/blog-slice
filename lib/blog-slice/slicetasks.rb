namespace :slices do
  namespace :blog_slice do 
    
    # add your own blog-slice tasks here
    
    # implement this to test for structural/code dependencies
    # like certain directories or availability of other files
    desc "Test for any dependencies"
    task :preflight do
    end
    
    # implement this to perform any database related setup steps
    desc "Migrate the database"
    task :migrate do
    end
    
    desc "Send Pingback"
    task :send_pingback do
      # From http://github.com/apotonick/pingback_engine/
      require 'xmlrpc/client'
      
      server = XMLRPC::Client.new2("http://localhost:4000/pingback")

      ok, param = server.call2("pingback.ping", ARGV[0], ARGV[1])

      if ok then
        puts "Response: #{param}"
      else
        puts "Error:"
        puts param.faultCode 
        puts param.faultString
      end
    end
    
    desc "Generate data"
    task :generate_data => :merb_env do
      include DataMapper::Sweatshop::Unique
      puts "Generate tags and categories..."
      
      Tag.fix {{
          :name => unique { /\w+/.gen }
      }}
      50.times { Tag.gen }
      
      Category.fix {{
        :name => unique { /\w+/.gen }
      }}
      
      10.times { Category.gen }
      
      puts "Generate posts..."
      
      Post.fix {{
        :title => (title = /[:sentence:]/.gen[0..48]),
        :content => /[:paragraph:] \n [:paragraph:] \n [:paragraph:]/.gen,
        :published_at => Time.now - (rand(365)).days,
        :slug => title.downcase.gsub(' ', '-')[0..48],
        :views_count => rand(100)
      }}
      
      100.times { Post.gen }
      
      Comment.fix {{
        :author => Randgen.name,
        :email => "#{/\w{10}/.gen}@email.com",
        :url => "http://#{/\w+/.gen}.com",
        :content => /[:paragraph:]/.gen,
        :approved => true,
        :ip_address => /\d{3}\.\d{3}\.\d{3}\.\d{3}/.gen # Ok, this could be better
      }}
      
      puts "Tag, Categorize and Comment Posts..."
      Post.all.each do |post|
        rand(5).times do
          category = Category.get(1 + rand(Category.count))
          post.categories << category if category
        end
        
        (2+rand(15)).times do
          tag = Tag.get(1+rand(Tag.count))
          post.tag(tag) if tag
        end
        
        rand(50).times do
          c = Comment.gen
          c.created_at = (post.published_at + (rand(48).hours + rand(60).minutes))
          c.post = post
          c.save
        end
        
        post.save
      end
      
      puts "done"
    end
    
  end
end