module Merb
  module BlogSlice
    module TextRendering
      def self.included(base)
        base.module_eval do
          property :rendered_content, DataMapper::Types::Text, :lazy => false, :writer => :protected  # Rendered html
          property :rendering_engine, String, :nullable => false, :default => 'textile' # Textile, Markdown, etc.
        
          before :valid?, :render_content

          def render_content
            return unless self.content
            if self.rendering_class
              self.rendered_content = self.rendering_class.new(self.content).to_html
            else
              self.rendered_content = self.content
            end
          end

          def rendering_class
            case self.rendering_engine
            when 'markdown'
              BlueCloth
            when 'textile'
              RedCloth
            else
              nil
            end
          end

          def self.rendering_engines
            [['textile', 'Textile'],  ['markdown', 'MarkDown'], ['html', 'HTML']]
          end
        end
      end
    end
  end
end
