class BlogSlice::Dashboard < BlogSlice::Application
  provides :html
  before :authorization_required
  
  def dashboard
    @dashboard = {:left => [:numbers, :posts, :drafts, :linkbacks], :right => [:tags, :comments]}
    render
  end
end