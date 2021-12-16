module WillPaginate
    module ViewHelpers
      # This class does the heavy lifting of actually building the pagination
      # links. It is used by +will_paginate+ helper internally.
      class PageNumberRendererBase
  
        # * +collection+ is a WillPaginate::Collection instance or any other object
        #   that conforms to that API
        # * +options+ are forwarded from +will_paginate+ view helper
        def prepare(options, current_page, total_pages)
          @current_page = current_page
          @total_pages = total_pages
          @options = options  
        end

        def numbers
          []
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
