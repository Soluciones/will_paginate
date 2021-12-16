require 'will_paginate/view_helpers/page_number_renderer_base'

module WillPaginate
    module ViewHelpers
      # This class does the heavy lifting of actually building the pagination
      # links. It is used by +will_paginate+ helper internally.
      class LogarithmicPageNumberRenderer < PageNumberRendererBase
        
        def numbers
          result = []
          a = b = 1
          total_step = 10
          left = @current_page == 1 ? [] : [@current_page-1]
          right = @current_page == @total_pages ? [] : [@current_page+1]

          # set the step and seed
          l_step = total_step * @current_page / @total_pages
          r_step = total_step - l_step
          l_seed = (@current_page-1) ** (1.0/(l_step+1).to_f)
          r_seed = (@total_pages-@current_page-1) ** (1.0/(r_step+1).to_f)

          #  left array
          while a < l_step + 1
            record_page = (@current_page-1-l_seed ** a).ceil()
            left.unshift(record_page)
            a = a + 1
          end

          #  right array
          while b < r_step + 1
            record_page = (@current_page+1+r_seed ** b).floor()
            right.push(record_page)
            b = b + 1
          end

          page_array = (left.unshift(1) + [@current_page.to_i] + right.push(@total_pages)).uniq()
          page_array.each_with_index do |p, idx|
            result << p 
            result << :gap if idx < page_array.length - 1
          end
          result
        end
    end
  end
end
