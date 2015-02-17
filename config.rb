require 'itamae'

class GenerateItamaeData < Middleman::Extension
  helpers do
    def resources
      result = {}

      Itamae::Resource.constants.map do |c|
        Itamae::Resource.const_get(c)
      end.select do |c|
        c.superclass == Itamae::Resource::Base
      end.each do |c|
        name = c.name.split('::').last.scan(/[A-Z][^A-Z]*/).map(&:downcase).join('_')
        result[name] = {
          attributes: c.defined_attributes,
          actions: c.instance_methods.map(&:to_s).map {|m| if m =~ /\Aaction_(.+)\z/; $1; end }.compact
        }
      end

      result.deep_merge(data.resources)
    end
  end
end

::Middleman::Extensions.register(:generate_itamae_data, GenerateItamaeData)

###
# Compass
###

# Change Compass configuration
# compass_config do |config|
#   config.output_style = :compact
# end

###
# Page options, layouts, aliases and proxies
###

# Per-page layout changes:
#
# With no layout
# page "/path/to/file.html", :layout => false
#
# With alternative layout
# page "/path/to/file.html", :layout => :otherlayout
#
# A path which all have the same layout
# with_layout :admin do
#   page "/admin/*"
# end

# Proxy pages (http://middlemanapp.com/basics/dynamic-pages/)
# proxy "/this-page-has-no-template.html", "/template-file.html", :locals => {
#  :which_fake_page => "Rendering a fake page with a local variable" }

###
# Helpers
###

# Automatic image dimensions on image_tag helper
# activate :automatic_image_sizes

# Reload the browser automatically whenever files change
# configure :development do
#   activate :livereload
# end

# Methods defined in the helpers block are available in templates
# helpers do
#   def some_helper
#     "Helping"
#   end
# end

set :css_dir, 'stylesheets'

set :js_dir, 'javascripts'

set :images_dir, 'images'

# Build-specific configuration
configure :build do
  # For example, change the Compass output style for deployment
  # activate :minify_css

  # Minify Javascript on build
  # activate :minify_javascript

  # Enable cache buster
  # activate :asset_hash

  # Use relative URLs
  # activate :relative_assets

  # Or use a different image path
  # set :http_prefix, "/Content/images/"
end

activate :deploy do |deploy|
  deploy.method = :git
  deploy.branch = 'master'
end

activate :generate_itamae_data
