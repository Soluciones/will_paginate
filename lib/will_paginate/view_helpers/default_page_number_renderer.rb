require 'will_paginate/view_helpers/page_number_renderer_base'

module WillPaginate
    module ViewHelpers
      
      # This class does the heavy lifting of actually building the pagination
      # links. It is used by +will_paginate+ helper internally.
      class DefaultPageNumberRenderer < PageNumberRendererBase
        
        # Calculates visible page numbers using the <tt>:inner_window</tt> and
        # <tt>:outer_window</tt> options.
        def numbers
          inner_window, outer_window = @options[:inner_window].to_i, @options[:outer_window].to_i
          window_from = @current_page - inner_window
          window_to = @current_page + inner_window
          
          # adjust lower or upper limit if either is out of bounds
          if window_to > @total_pages
            window_from -= window_to - @total_pages
            window_to = @total_pages
          end
          if window_from < 1
            window_to += 1 - window_from
            window_from = 1
            window_to = @total_pages if window_to > @total_pages
          end
          
          # these are always visible
          middle = window_from..window_to

          # left window
          if outer_window + 3 < middle.first # there's a gap
            left = (1..(outer_window + 1)).to_a
            left << :gap
            left << ((outer_window + 1 + middle.first)/2).floor
            left << :gap
          else # runs into visible pages
            left = 1...middle.first
          end

          # right window
          if @total_pages - outer_window - 2 > middle.last # again, gap
            right = ((@total_pages - outer_window)..@total_pages).to_a
            right.unshift :gap
            right.unshift ((@total_pages - outer_window + middle.last)/2).floor
            right.unshift :gap
          else # runs into visible pages
            right = (middle.last + 1)..@total_pages  
          end
          
          left.to_a + middle.to_a + right.to_a
        end
    end
  end
end
