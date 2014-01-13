require_relative '_rake/helpers'
import '_rake/jekyll-create-tag-pages-rakefile.rb'
import '_rake/jekyll-create-shop-pages-rakefile.rb'
import '_rake/jekyll-create-running-page-rakefile.rb'
import '_rake/jekyll-create-welcome-page-rakefile.rb'
import '_rake/jekyll-create-category-data.rb'
import '_rake/jekyll-create-related-data.rb'
import '_rake/jekyll-create-category-index-pages.rb'
import '_rake/jekyll-create-producturlmap-data.rb'

task :default => [:products, :producturlmap_data, :category_data, :categories, :tags, :related]

task :marketing => [:running, :welcome]
