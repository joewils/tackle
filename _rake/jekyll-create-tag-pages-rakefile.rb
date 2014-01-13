desc 'Generate Tag Pages'

# Inspiration: 
# http://gist.github.com/262512
# https://gist.github.com/pkazmierczak/1554185

task :tags do

  puts "Generating Tag Pages..."
  require 'rubygems'
  require 'jekyll'
  require 'yaml'
  require 'pp'
  include Jekyll::Filters
  
  options = Jekyll.configuration({})
  site = Jekyll::Site.new(options)
  site.read_posts('')

  products = YAML.load_file('_data/products.yml')

   # Posts
  site.tags.sort.each do |tag, posts|

    # YML Front Matter
    html = "---\n";
    html += "layout: tags\n";
    html += "title: " + tag + "\n";
    html += "---\n\n";

    # Posts
    html += "<div class=\"row\">\n\n"
    posts.reverse.each do |post|
      post_data = post.to_liquid
      pid = post_data['sku']
      html += "<div class=\"col-xs-6 col-sm-4 col-md-3\">\n"
        html += "<div class=\"thumbnail\" style=\"margin-bottom:30px;max-width:300px;\">\n"

          html += "<div class=\"caption\" style=\"height:50px;overflow:hidden\">\n"
            html += "<p>"
            html += "<a href=\"" + site.baseurl + post_data["url"] + "\">"
            html += post_data["title"]
            html += "</a></p>\n"
          html += "</div>\n"

          html += "<div style=\"height:200px;width:100%;overflow:hidden\">\n"
            html += "<a href=\"" + site.baseurl + post_data["url"] + "\">\n"
            html += "<img src=\"" + products[pid]['image_url'] + "\" class=\"img-responsive\" />\n"
            html += "</a>\n"
          html += "</div>\n"

        html += "</div>\n"
      html += "</div>\n\n"
    end
    html += "</div>\n\n"
    
    # Page
    file = 'tags/' + tag + '/index.html'
    FileUtils.mkdir_p(File.dirname(file)) unless File.exists?(File.dirname(file))
    File.open(file, 'w+') do |file|
      file.puts html
    end

  end

  puts 'Done.'

end