require 'middleman-core'
require 'middleman/contrib/version'
require 'middleman/contrib/extension'

::Middleman::Extensions.register(:contrib) do  
  ::Middleman::Contrib::Extension
end
