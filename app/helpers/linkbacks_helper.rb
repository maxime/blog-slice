module Merb
  module BlogSlice
    module LinkbacksHelper
      def linkback_form_definition
        {:attributes => [ 
            {:blog_name => {:control => :text}},
  					{:target_url => {:control => :text}},
  					{:title => {:control => :text}},
  					{:source_url => {:control => :text}},
  					{:type => {:control => :text}},
  					{:excerpt => {:control => :text_area}}
          ],
         :nested_within => :post
        }
      end
    end
  end
end # Merb