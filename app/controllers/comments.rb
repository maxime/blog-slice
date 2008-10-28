class BlogSlice::Comments < BlogSlice::Application
  provides :html, :xml, :rss
  before :authorization_required, :exclude => [:index, :show, :new, :create]
  before :get_post
  
  def index
    @comments = @post.comments
    display @comments
  end
  
  def new
    @comment = @post.comments.new
    render :form
  end
  
  def create
    @comment = Comment.new(params[:comment])
    @comment.post = @post
    if @comment.save
      redirect slice_url(:post, :id => @post.slug)
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
      redirect slice_url(:post, :id => @post.slug)
    else
      render :form
    end
  end
  
  def destroy
    @comment = @post.comments.get(params[:id])
    raise NotFound unless @comment

    @comment.destroy
    redirect slice_url(:post, :id => @post.slug)
  end
  
  protected
  
  def get_post
    @post = Post.first(:slug => params[:post_id])
    raise NotFound unless @post
  end
end