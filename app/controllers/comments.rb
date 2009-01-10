class BlogSlice::Comments < BlogSlice::Application
  provides :html, :xml, :rss
  before :authorization_required, :exclude => [:index, :show, :new, :create, :feed]
  before :get_post, :exclude => [:moderate]
  
  def index
    @comments = @post.comments
    display @comments
  end
  
  def new
    @comment = @post.comments.new
    render :form
  end
  
  def create
    @comment = Comment.new(negative_captcha_params(:comment))
    @comment.post = @post
    
    @comment.approved = authorized? || !comment_options[:moderate]
    
    if @comment.save
      
      if comment_options[:notify_on_creation]
        send_mail(BlogSlice::CommentMailer, :notify, {
              :from => comment_options[:notify_on_creation_sender],
              :to => comment_options[:notify_on_creation],
              :subject => "New comment on your post #{@post.title}"},
              {:comment => @comment, :post => @post })
      end
      
      redirect resource(@post), :message => {:notice => (@comment.approved ? 'Your comment has been posted' : 'Your comment is awaiting moderation')}
    else
      render :form
    end
  end
  
  def edit
    @comment = @post.comments.get(params[:id])
    raise NotFound unless @comment
    render :form
  end
  
  def update
    @comment = @post.comments.get(params[:id])
    raise NotFound unless @comment

    if @comment.update_attributes(params[:comment]) || !@comment.dirty?
      redirect resource(@post), :message => {:notice => "The comment has been sucessfully updated"}
    else
      render :form
    end
  end
  
  def destroy
    @comment = @post.comments.get(params[:id])
    raise NotFound unless @comment

    @comment.destroy
    redirect resource(@post)
  end
  
  def feed
    only_provides :rss
    @comments = @post.comments.all(:limit => blog_options[:feed_number_of_items], :order => [:created_at.desc])
    Merb.logger.info "@comments.size #{@comments.size}"
    render :layout => false
  end
  
  def moderate
    raise NotFound unless comment_options[:moderate]
    @comments = Comment.all(:approved => false, :order => [:created_at.desc])
    display @comments
  end
  
  def approve
    raise NotFound unless comment_options[:moderate]
    @comment = Comment.get(params[:id])
    raise NotFound unless @comment
    @comment.update_attributes(:approved => true)
    redirect slice_url(:moderate_comments), :message => {:notice => "Comment has been successfully approved"}
  end
  
  protected
  
  def get_post
    @post = Post.first(:slug => params[:slug])
    raise NotFound unless @post
  end
end