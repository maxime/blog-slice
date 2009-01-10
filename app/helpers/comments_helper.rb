module Merb
  module BlogSlice
    module CommentsHelper
      # Form definition for simple forms
      def comment_form_definition
        {:attributes => [ {:author =>             {:label => "Name", :control => :text_field}},
                          {:email =>              {:label => "Mail", :control => :text_field}},
                          {:url =>                {:label => "Website", :control => :text_field}},
                          {:content =>            {:label => "Comment", :control => :text_area, :rows => 3}}],
         :nested_within => 'posts',
         :slice => true,
         :cancel_url => false,
         :negative_captcha => {
              :secret => negative_captcha_secret, 
              :spinner => request.remote_ip  
            },
         :submit => 'Submit'}
      end
    end
  end
end