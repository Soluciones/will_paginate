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
        items = @options[:page_links] ? windowed_logarithmic_page_numbers : []
        items.unshift :previous_page
        items.push :next_page
      end

    protected
    
      # Calculates visible page numbers using the <tt>:inner_window</tt> and
      # <tt>:outer_window</tt> options.
      def windowed_page_numbers
        inner_window, outer_window = @options[:inner_window].to_i, @options[:outer_window].to_i
        window_from = current_page - inner_window
        window_to = current_page + inner_window
        
        # adjust lower or upper limit if either is out of bounds
        if window_to > total_pages
          window_from -= window_to - total_pages
          window_to = total_pages
        end
        if window_from < 1
          window_to += 1 - window_from
          window_from = 1
          window_to = total_pages if window_to > total_pages
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
        if total_pages - outer_window - 2 > middle.last # again, gap
          right = ((total_pages - outer_window)..total_pages).to_a
          right.unshift :gap
          right.unshift ((total_pages - outer_window + middle.last)/2).floor
          right.unshift :gap
        else # runs into visible pages
          right = (middle.last + 1)..total_pages  
        end
        
        left.to_a + middle.to_a + right.to_a
      end

      def windowed_logarithmic_page_numbers

        current_page = 25
        total_pages = 100

        result = []
        page_array = logarithmic(current_page, total_pages)
        page_array.each do |p|
          result << p
          result << :gap
        end
        result
      end

      def logarithmic(cp, tp)
        left = cp > 2 ? [cp-1] : []
        right = cp < tp-2 ? [cp+1] : []
               
        l_step = 10 * cp / tp > 0 ? 10 * cp / tp : 1
        r_step = 10 - l_step
         
        l_seed = l_step == 1 ? cp/2 : Math.log(cp-1, l_step)
        r_seed = r_step == 1 ? (tp-cp)/2 : Math.log(tp-cp-1, r_step)

        #  left array
        a = b = 1
        while cp-1-l_seed ** a > 1
          left.unshift((cp-1-l_seed ** a).floor())
          a = a + 1
        end

        #  right array
        while cp+1+r_seed ** b < tp
          right.push((cp+1+r_seed ** b).floor())
          b = b + 1
        end
        result = left.unshift(1) + [cp] + right.push(tp)
        result = result.uniq()
        
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
