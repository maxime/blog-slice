class BlogSlice::Tags < BlogSlice::Application
  provides :html, :xml
  
  def index
    @tags = Tag.all
    display @tags
  end
  
  def show
    @tag = Tag.first(:slug => params[:slug])
    raise NotFound unless @tag
    @posts = @tag.posts.paginate(:page => params[:page], :order => [:published_at.desc])
    display @posts
  end
  
  # update received from the in place editor in the dashboard
  def update
    @tag = Tag.first(:slug => params[:slug])
    raise NotFound unless @tag
    
    @tag.name = params[:update_value]
    
    if @tag.save
      @tag.name
    else
      render :update, :status => 500, :layout => false
    end 
  end
end