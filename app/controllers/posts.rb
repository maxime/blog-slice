class BlogSlice::Posts < BlogSlice::Application
  provides :html, :xml
  before :authorization_required, :exclude => [:index, :show]
  before :get_post, :only => [:show, :edit, :update, :destroy]
  
  def index
    @posts = Post.all
    display @posts
  end
  
  def new
    @post = Post.new
    render :form
  end
  
  def create
    @post = Post.new(params[:post])
    if @post.save
      redirect url(:blog_slice_post, :id => @post.slug)
    else
      render :form
    end
  end
  
  def show
    display @post
  end
  
  def edit
    render :form
  end
  
  def update
    if @post.update_attributes(params[:post])
      redirect url(:blog_slice_post, :id => @post.slug)
    else
      render :form
    end
  end
  
  def destroy
    @post.destroy
    redirect url(:blog_slice_posts)
  end
  
  protected
  
  def get_post
    @post = Post.first(:slug => params[:id])
    raise NotFound unless @post    
  end
end