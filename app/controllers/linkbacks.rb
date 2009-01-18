class BlogSlice::Linkbacks < BlogSlice::Application
  before :get_post
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

  def new
    only_provides :html
    @linkback = Linkback.new
    display @linkback, :form
  end

  def edit
    only_provides :html
    @linkback = (@post ? @post.linkbacks.get(params[:id]) : Linkback.get(params[:id]))
    raise NotFound unless @linkback
    display @linkback, :form
  end

  def create
    @linkback = Linkback.new(params[:linkback])
    @linkback.post = @post
    if @linkback.save
      redirect (@post ? resource(@post, @linkback) : resource(@linkback)), :message => {:notice => "Linkback was successfully created"}
    else
      message[:error] = "Linkback failed to be created"
      display @linkback, :form
    end
  end

  def update
    @linkback = (@post ? @post.linkbacks.get(params[:id]) : Linkback.get(params[:id]))
    raise NotFound unless @linkback
    if @linkback.update_attributes(params[:linkback])
      redirect (@post ? resource(@post, @linkback) : resource(@linkback))
    else
      display @linkback, :form
    end
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
  
  protected
  
  def get_post
    @post = Post.get(params[:slug])
    raise NotFound unless @post || params[:slug].nil?
  end
end # Linkbacks
