class BlogSlice::Categories < BlogSlice::Application
  provides :xml, :html
  before :authorization_required, :exclude => [:index, :show]

  def index
    @categories = Category.all
    display @categories
  end

  def show
    @category = Category.first(:slug => params[:slug])
    raise NotFound unless @category
    @posts = @category.posts.paginate(:page => params[:page], :order => [:published_at.desc])
    display @category
  end

  def new
    only_provides :html
    @category = Category.new
    display @category, :form
  end

  def edit
    only_provides :html
    @category = Category.first(:slug => params[:slug])
    raise NotFound unless @category
    display @category, :form
  end

  def create
    @category = Category.new(params[:category])
    if @category.save
      redirect resource(@category), :message => {:notice => "Category was successfully created"}
    else
      message[:error] = "Category failed to be created"
      display @category, :form
    end
  end

  def update
    @category = Category.first(:slug => params[:slug])
    raise NotFound unless @category
    if @category.update_attributes(params[:category])
      redirect resource(@category), :message => {:notice => "Category was successfully updated"}
    else
      display @category, :form
    end
  end

  def destroy
    @category = Category.first(:slug => params[:slug])
    raise NotFound unless @category
    if @category.destroy
      redirect resource(:categories)
    else
      raise InternalServerError
    end
  end
end # Categories
