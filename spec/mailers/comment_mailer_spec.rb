require File.join(File.dirname(__FILE__),'..','spec_helper')

# Helper

def describe_mail(mailer, template, &block)
  describe "/#{mailer.to_s.downcase}/#{template}" do
    before :each do
      @mailer_class, @template = mailer, template
      @assigns = {}
    end
 
    def deliver(send_params={}, mail_params={})
      mail_params = {:from => "from@example.com", :to => "to@example.com", :subject => "Subject Line"}.merge(mail_params)
      @mailer_class.new(send_params).dispatch_and_deliver @template.to_sym, mail_params
      @mail = Merb::Mailer.deliveries.last
    end
 
    instance_eval &block
  end
end

describe BlogSlice::CommentMailer, :notify do
  before :each do
    @comment = Comment.new(:author => "Maxime", :email => 'maxime@email.com', :content => "Bla")
    @post = Post.new(:slug => "my-first-blog-post", :title => "My First Blog Post")
    
    mailer = BlogSlice::CommentMailer.new({:comment => @comment, :post => @post })
                                  
    mailer.dispatch_and_deliver :notify, {:from => "sender@email.com",
                                          :to => "blogger@email.com",
                                          :subject => "New comment on your post #{@post.title}"}
          
    @mail = Merb::Mailer.deliveries.last     
  end
  
  it "should send the comment author" do
    @mail.html.should =~ /Maxime/
  end

  it "should send the comment content" do
    @mail.html.should =~ /Bla/
  end
end