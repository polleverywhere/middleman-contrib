module Middleman
  module Contrib
    
    module Helpers
      def sub_pages(dir_path, opts={})
        opts     = opts.dup
        dir_path = dir_path.chomp('/')
        dir_path = "#{dir_path}/" if dir_path != ''

        opts[:filter] ||= //
        opts[:max_depth] += (dir_path.count('/') - 1) if opts[:max_depth]

        resources = sitemap.resources.select do |resource|
          path = resource.path

          path.start_with?(dir_path) && path =~ opts[:filter] &&
          (!opts[:max_depth] || path.count('/') <= opts[:max_depth])
        end

        resources.sort_by { |resource| [resource.path.count('/'), resource.path] }
        
        # selector = case dir_path
        # when String
        #   dir_path = "#{dir_path.chomp '/'}/"
        #   proc { |resource| resource.path.start_with?(dir_path) }
        # when Regexp
        #   proc { |resource| resource.path =~ dir_path }
        # end
        
        # sitemap.resources.select(&selector).sort_by(&sort)
      end 
    end

  end
end
