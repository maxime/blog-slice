module Merb
  module BlogSlice
    module PostsHelper
      # Form definition for simple forms
      def post_form_definition
        {:attributes => [ {:title =>              {:control => :text_field}}, 
                          {:content =>            {:control => :text_area}},
                          {:rendering_engine =>   {:control => :select, :collection => Post.rendering_engines}},
                          {:tags_list =>          {:control => :text_field, :label => 'Tags'}},
                          {:published_at =>       {:control => :date_and_time}}
                        ],
         :slice => true}
      end
    end
  end
end