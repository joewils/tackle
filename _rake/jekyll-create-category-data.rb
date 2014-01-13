desc 'Generate Category Data'

task :category_data do

  puts "Generating Category Data..."
  require 'rubygems'
  require 'yaml'
  require 'pp'
  require 'jekyll'

  # Site Data
  include Jekyll::Filters
  options = Jekyll.configuration({})
  site = Jekyll::Site.new(options)
  site.read_posts('')

  categories = Hash.new

  site.posts.each do |post|
    data = post.to_liquid

    next if data['categories'].length != 3

    primary_category = data['categories'][0]
    secondary_category = data['categories'][1]
    tertiary_category = data['categories'][2]

    # Normalize Categories
    primary_category = normalize_category(primary_category) 

    # Primary Categories
    if (categories[primary_category].is_a?(Hash)) 
      categories[primary_category]['products'].push(data['sku'])
    else
      categories[primary_category] = Hash.new
      categories[primary_category]['children'] = Hash.new
      categories[primary_category]['products'] = Array.new
      categories[primary_category]['products'].push(data['sku'])
    end

    # Secondary Categories
    if (categories[primary_category]['children'][secondary_category].is_a?(Hash)) 
      categories[primary_category]['children'][secondary_category]['products'].push(data['sku'])
    else
      categories[primary_category]['children'][secondary_category] = Hash.new
      categories[primary_category]['children'][secondary_category]['children'] = Hash.new
      categories[primary_category]['children'][secondary_category]['products'] = Array.new
      categories[primary_category]['children'][secondary_category]['products'].push(data['sku'])
    end

    # Tertiary Categories
    if (categories[primary_category]['children'][secondary_category]['children'][tertiary_category].is_a?(Hash)) 
      categories[primary_category]['children'][secondary_category]['children'][tertiary_category]['products'].push(data['sku'])
    else
      categories[primary_category]['children'][secondary_category]['children'][tertiary_category] = Hash.new
      categories[primary_category]['children'][secondary_category]['children'][tertiary_category]['products'] = Array.new
      categories[primary_category]['children'][secondary_category]['children'][tertiary_category]['products'].push(data['sku'])
    end

  end

  # YAML Category Data
  File.open("_data/categories.yml", 'w+') do |file|
    file.puts categories.to_yaml(line_width: -1)
  end

  # JSON Category Data
  File.open("json/categories.json", 'w+') do |file|
    file.puts categories.to_json()
  end

  puts 'Done.'

end