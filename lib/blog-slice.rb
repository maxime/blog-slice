if defined?(Merb::Plugins)

  $:.unshift File.dirname(__FILE__)

  dependency 'merb-slices'
  Merb::Plugins.add_rakefiles "blog-slice/merbtasks", "blog-slice/slicetasks", "blog-slice/spectasks"

  # Register the Slice for the current host application
  Merb::Slices::register(__FILE__)
  
  # Slice configuration - set this in a before_app_loads callback.
  # By default a Slice uses its own layout, so you can swicht to 
  # the main application layout or no layout at all if needed.
  # 
  # Configuration options:
  # :layout - the layout to use; defaults to :blog-slice
  # :mirror - which path component types to use on copy operations; defaults to all
  Merb::Slices::config[:blog_slice][:layout] ||= :blog_slice
  
  # All Slice code is expected to be namespaced inside a module
  module BlogSlice
    
    # Slice metadata
    self.description = "Blog Slice is a very basic blogging system"
    self.version = "0.9.10"
    self.author = "Maxime Guilbot for Ekohe"
    
    Merb.add_mime_type :rss, nil, %w[text/xml]
    
    # Stub classes loaded hook - runs before LoadClasses BootLoader
    # right after a slice's classes have been loaded internally.
    def self.loaded
    end
    
    # Initialization hook - runs before AfterAppLoads BootLoader
    def self.init
    end
    
    # Activation hook - runs after AfterAppLoads BootLoader
    def self.activate
    end
    
    # Deactivation hook - triggered by Merb::Slices.deactivate(BlogSlice)
    def self.deactivate
    end
    
    # Setup routes inside the host application
    #
    # @param scope<Merb::Router::Behaviour>
    #  Routes will be added within this scope (namespace). In fact, any 
    #  router behaviour is a valid namespace, so you can attach
    #  routes at any level of your router setup.
    #
    # @note prefix your named routes with :blog_slice_
    #   to avoid potential conflicts with global named routes.
    def self.setup_router(scope)
      scope.match("/").to(:controller => 'posts', :action => 'index').name(:posts)

      scope.resources :posts, :identify => :slug do |posts|
        posts.resources :comments, :identify => :id do |comments|
          comments.collection :feed
          comments.member :approve, :method => :post
        end

        posts.resources :linkbacks do |linkbacks|
          linkbacks.member :approve, :method => :post
        end

        posts.member :trackback
      end
      
      scope.resources :linkbacks do |linkbacks|
        linkbacks.member :approve, :method => :post        
      end
      scope.resources :categories, :identify => :slug
      scope.resources :tags, :identify => :slug
      
      scope.match("/feed").to(:controller => 'posts', :action => 'feed', :format => 'rss').name(:feed)
      scope.match("/dashboard").to(:controller => 'dashboard', :action => 'dashboard').name(:dashboard)
      scope.match("/moderate_comments").to(:controller => 'comments', :action => 'moderate').name(:moderate_comments)
    end
    
  end
  
  # Setup the slice layout for BlogSlice
  #
  # Use BlogSlice.push_path and BlogSlice.push_app_path
  # to set paths to blog-slice-level and app-level paths. Example:
  #
  # BlogSlice.push_path(:application, BlogSlice.root)
  # BlogSlice.push_app_path(:application, Merb.root / 'slices' / 'blog-slice')
  # ...
  #
  # Any component path that hasn't been set will default to BlogSlice.root
  #
  # Or just call setup_default_structure! to setup a basic Merb MVC structure.
  BlogSlice.setup_default_structure!
  
  # Add dependencies for other BlogSlice classes below. Example:
  # dependency "blog-slice/other"
  # dependency "dm-core"

  dependency "dm-is-slug"
  dependency "dm-is-taggable"
  dependency "dm-validations"
  dependency "dm-timestamps"
  dependency "dm-sweatshop"
  dependency "merb-haml"
  dependency "merb-helpers"
  dependency "merb-simple-forms"
  dependency "RedCloth"
  dependency "BlueCloth"
  dependency "merb_builder"
  dependency "merb-mailer"
  require "will_paginate"
  
  require 'blog-slice/text_rendering'
end