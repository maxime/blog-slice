class BlogSlice::Application < Merb::Controller
  include Merb::Helpers::SimpleFormsHelpers
  controller_for_slice
  
  def authorization_required
    unless authorized?
      raise Unauthorized
      throw :halt
    end
  end
  
  def authorized?
    true
  end
end