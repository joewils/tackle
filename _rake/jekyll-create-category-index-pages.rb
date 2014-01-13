desc 'Generate Category Index Pages'

task :categories do

  puts "Generating Category Index Pages..."
  require 'rubygems'
  require 'yaml'
  require 'pp'

  products = YAML.load_file('_data/products.yml')
  categories = YAML.load_file('_data/categories.yml')
  
  # Primary Index Pages
  categories.each do |category|
    primary_category = category[0]
    build_category_front_matter(category, primary_category)

    # Secondary Index Pages
    category[1]['children'].each do |category|
      secondary_category = category[0]
      build_category_front_matter(category, primary_category + '/' + secondary_category)
      # Tertiary Index Pages
      category[1]['children'].each do |category|
        tertiary_category = category[0]
        build_category_front_matter(category, primary_category + '/' + secondary_category + '/' + tertiary_category)
      end
    end
  end

  puts 'Done.'

end