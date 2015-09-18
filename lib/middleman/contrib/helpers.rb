module Middleman
  module Contrib
    
    module Helpers
      def sub_pages(dir_path, &sort)
        sort ||= proc {}
        
        selector = case dir_path
        when String
          dir_path = "#{dir_path.chomp '/'}/"
          proc { |resource| resource.path.start_with?(dir_path) }
        when Regexp
          proc { |resource| resource.path =~ dir_path }
        end
        
        sitemap.resources.select(&selector).sort_by(&sort)
      end 
    end

  end
end
