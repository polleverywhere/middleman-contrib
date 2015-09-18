require 'middleman/contrib/helpers'

module Middleman
  module Contrib

    # Extension namespace
    class Extension < ::Middleman::Extension
      # Helpers for use within templates and layouts.
      self.defined_helpers = [::Middleman::Contrib::Helpers]

      def initialize(app, options_hash={}, &block)
        # Call super to build options from the options_hash
        super
      end
    end

  end
end