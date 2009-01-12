class BlogSlice::Dashboard < BlogSlice::Application
  provides :html
  before :authorization_required
  
  def dashboard
    render
  end
end