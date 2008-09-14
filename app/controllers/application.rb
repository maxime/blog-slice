class BlogSlice::Application < Merb::Controller
  include Merb::Helpers::SimpleFormsHelpers
  
  controller_for_slice
end