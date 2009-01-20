module Merb
  module BlogSlice
    module PostsHelper
      # Form definition for simple forms
      def post_form_definition
        {:attributes => [ {:title =>              {:control => :text_field}}, 
                          {:content =>            {:control => :text_area, :style => 'height: 450px'}},
                          {:rendering_engine =>   {:control => :select, :collection => Post.rendering_engines}},
                          {:tags_list =>          {:control => :text_field, :label => 'Tags'}},
                          {:categories_ids =>     {:control => :multiple_checkboxes, :label => 'Categories', :collection => Category.all.collect{|c| [c.id, c.name]} }},
                          {:published_at =>       {:control => :date_and_time}},
                          {:separator =>          {:label => "Options"}},
                          {:allow_comments =>     {:control => :checkbox, :label => false, :after => "Enable Comments"}},
                          {:allow_linkbacks =>    {:control => :checkbox, :label => false, :after => "Enable Linkbacks (Trackbacks & Pingbacks)"}},
                          {:status =>             {:control => :select, :collection => post_status_collection}}
                        ],
         :slice => true}
      end
      
      def post_status_collection
        collection = []
        Post::STATUS.each_with_index do |status, index|
          collection << [index.to_s, Extlib::Inflection.humanize(status.to_s)]
        end
        collection
      end
    end
  end
end