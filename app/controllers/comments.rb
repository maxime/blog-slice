class BlogSlice::Comments < BlogSlice::Application
  provides :html, :xml, :rss
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
    @comment = @post.comments.new(params[:comment])
    if @comment.save
      redirect url(:blog_slice_post_comments, :post_id => @post.slug)
    else
      render :form
    end
  end
  
  protected
  
  def get_post
    @post = Post.first(:slug => params[:post_id])
    raise NotFound unless @post
  end
end