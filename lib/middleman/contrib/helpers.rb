module Middleman
  module Contrib
    
    module Helpers
      # Middleman view helper that returns an array of pages found inside the
      # specified directory.
      #
      # @param dir_path [String] The relative path to the directory whose
      #   sub-pages will be returned
      # @param filter [Regexp] Optional matcher to filter path names on
      # @param max_depth [Integer] Optionally limit how deep to match inside
      #   the path
      # @return [Array<Middleman::Sitemap::Resource>] All resources matching
      #   specified limitations set by the parameters.
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
      end 
    end

  end
end
