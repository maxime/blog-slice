class BlogSlice::Posts < BlogSlice::Application
  provides :html, :xml, :rss
  before :authorization_required, :exclude => [:index, :show, :feed]
  before :get_post, :only => [:show, :edit, :update, :destroy]
  
  include Merb::BlogSlice::CommentsHelper
  
  def index
    @posts = Post.paginate(:page => params[:page], :order => [:published_at.desc])
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
    @posts = Post.all(:limit => blog_options[:feed_number_of_items], :order => [:created_at.desc])
    render :layout => false
  end
  
  protected
  
  def get_post
    @post = Post.first(:slug => params[:slug])
    raise NotFound unless @post    
    @title = @post.title
  end
end