module Merb
  module BlogSlice
    module CategoriesHelper
      def category_form_definition
        {:attributes => [ 
            {:name => {:control => :text}}
          ]
        }
      end
    end
  end
end # Merb