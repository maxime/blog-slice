class BlogSlice::Posts < BlogSlice::Application
  provides :html, :xml
  
  def index
    @posts = Post.all
    display @posts
  end
  
  def new
    @post = Post.new
    render :form
  end
end