class BlogSlice::Linkbacks < BlogSlice::Application
  before :get_post
  before :authorization_required
  # provides :xml, :yaml, :js

  def index
    @linkbacks = (@post ? @post.linkbacks : Linkback.all)
    display @linkbacks
  end

  def show
    @linkback = (@post ? @post.linkbacks.get(params[:id]) : Linkback.get(params[:id]))
    raise NotFound unless @linkback
    display @linkback
  end

  def destroy
    @linkback = (@post ? @post.linkbacks.get(params[:id]) : Linkback.get(params[:id]))
    raise NotFound unless @linkback
    if @linkback.destroy
      redirect (@post ? resource(@post, :linkbacks) : resource(:linkbacks))
    else
      raise InternalServerError
    end
  end

  def approve
    @linkback = (@post ? @post.linkbacks.get(params[:id]) : Linkback.get(params[:id]))
    raise NotFound unless @linkback

    @linkback.update_attributes(:approved => true)
    redirect slice_url(:dashboard), :message => {:notice => "Linkback has been approved"}
  end
  
  protected
  
  def get_post
    @post = Post.get(params[:slug])
    raise NotFound unless @post || params[:slug].nil?
  end
end # Linkbacks
