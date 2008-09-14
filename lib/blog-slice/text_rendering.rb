module Merb
  module BlogSlice
    module TextRendering
      def self.included(base)
        base.module_eval do
          property :rendered_content, DataMapper::Types::Text, :writer => :protected  # Rendered html
          property :rendering_engine, String, :nullable => false, :default => 'textile' # Textile, Markdown, etc.
        
          before :valid?, :render_content

          def render_content
            return unless self.content
            self.rendered_content = self.rendering_class.new(self.content).to_html
          end

          def rendering_class
            case self.rendering_engine
            when 'markdown'
              BlueCloth
            else
              RedCloth
            end
          end
        end
      end
    end
  end
end
