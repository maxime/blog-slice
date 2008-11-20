class BlogSlice::Tags < BlogSlice::Application
  provides :html, :xml
  
  def index
    @tags = Tag.all
    display @tags
  end
  
  def show
    @tag = Tag.first(:slug => params[:slug])
    @posts = @tag.posts.paginate(:page => params[:page], :order => [:published_at.desc])
    display @posts
  end
end