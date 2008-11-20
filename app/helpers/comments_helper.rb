module Merb
  module BlogSlice
    module CommentsHelper
      # Form definition for simple forms
      def comment_form_definition
        {:attributes => [ {:author =>             {:control => :text_field}},
                          {:url =>                {:control => :text_field}},
                          {:email =>              {:control => :text_field}},
                          {:content =>            {:control => :text_area}}],
         :nested_within => 'posts',
         :slice => true,
         :cancel_url => false}
      end
    end
  end
end