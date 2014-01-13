desc 'Generate Product URL Data'

task :producturlmap_data do

  puts "Generating Product URL Data..."
  require 'rubygems'
  require 'yaml'
  require 'pp'
  require 'jekyll'

  # Site Data
  include Jekyll::Filters
  options = Jekyll.configuration({})
  site = Jekyll::Site.new(options)
  site.read_posts('')

  products = Hash.new

  site.posts.each do |post|
    data = post.to_liquid
    products[data['sku']] = post.url
  end

  # YAML Product URL Data
  File.open("_data/producturlmap.yml", 'w+') do |file|
    file.puts products.to_yaml(line_width: -1)
  end

  # JSON Product URL Data
  File.open("json/producturlmap.json", 'w+') do |file|
    file.puts products.to_json()
  end

  puts 'Done.'

end