require 'will_paginate/view_helpers/default_page_number_renderer'
require 'will_paginate/view_helpers/logarithmic_page_number_renderer'

module WillPaginate
  module ViewHelpers
    # This class does the heavy lifting of actually building the pagination
    # links. It is used by +will_paginate+ helper internally.
    class LinkRendererBase

      # * +collection+ is a WillPaginate::Collection instance or any other object
      #   that conforms to that API
      # * +options+ are forwarded from +will_paginate+ view helper
      def prepare(collection, options)
        @collection = collection
        @options    = options

        # reset values in case we're re-using this instance
        @total_pages = nil
      end
      
      def pagination
        items = @options[:page_links] ? windowed_page_numbers : []
        items.unshift :previous_page
        items.push :next_page
      end

      protected    
      
      def windowed_page_numbers
        renderer = case @options[:algorithm]
          when 'logarithmic'
            LogarithmicPageNumberRenderer.new
          else
            DefaultPageNumberRenderer.new
          end
        renderer.prepare(@options, current_page, total_pages)
        renderer.numbers
      end

      private

      def current_page
        @collection.current_page
      end

      def total_pages
        @total_pages ||= @collection.total_pages
      end

    end
  end
end
