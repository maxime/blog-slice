class BlogSlice::Posts < BlogSlice::Application
  provides :html, :xml, :rss
  before :authorization_required, :exclude => [:index, :show, :feed, :trackback]
  before :get_post, :only => [:show, :edit, :update, :destroy, :trackback]
  
  include Merb::BlogSlice::CommentsHelper
  
  def index
    @posts = Post.paginate(:status => 0, :published_at.lt => Time.now, :page => params[:page], :order => [:published_at.desc])
    display @posts
  end
  
  def new
    @post = Post.new
    @title = "Write a new post"
    render :form
  end
  
  def create
    @post = Post.new(params[:post])
    if @post.save
      redirect resource(@post), :message => {:notice => "Post was successfully created"}
    else
      render :form
    end
  end
  
  def show
    # Increase view count
    @post.update_attributes(:views_count => ((@post.views_count || 0) + 1))
    
    # If the post published at in the future, raise NotFound
    raise NotFound if (@post.published_at > Time.now) || (!authorized? && @post.status!=0)
    
    @comments = @post.comments
    @comment = Comment.new
    display @post
  end
  
  def edit
    @title = "Edit &laquo; #{@title}"
    render :form
  end
  
  def update
    @title = "Edit &laquo; #{@title}"
    if @post.update_attributes(params[:post]) || !@post.dirty? 
      redirect resource(@post), :message => {:notice => "Post was successfully updated"}
    else
      render :form
    end
  end
  
  def destroy
    @post.destroy
    redirect slice_url(:posts)
  end
  
  def feed
    only_provides :rss
    @posts = Post.all(:published_at.lt => Time.now, :limit => blog_options[:feed_number_of_items], :order => [:created_at.desc])
    render :layout => false
  end
  
  def trackback
    only_provides :html, :xml

    if request.method == :get
      render :trackback_help
    elsif request.method == :post
      attributes = {:source_url => params[:url], :type => 'trackback', :direction => true}
      
      [:title, :excerpt, :blog_name].each do |key|
        attributes.merge!({key => params[key]}) if params[key] and !params[key].empty?
      end
      
      @linkback = Linkback.new(attributes)
      
      if @linkback.save
        render :trackback_success, :format => :xml, :layout => false
      else
        render :trackback_failure, :format => :xml, :layout => false        
      end
    end
  end
  
  protected
  
  def get_post
    @post = Post.first(:slug => params[:slug])
    raise NotFound unless @post    
    @title = @post.title
  end
end