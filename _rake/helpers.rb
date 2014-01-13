def build_category_front_matter (category, heritage='')
  post = Hash.new
  post['layout'] = 'category'
  post['title'] = titleize(category[0])
  post['category'] = category[0]
  post['heritage'] = heritage.split('/')
  if (category[1]['children'])
    post['children'] = Array.new
    category[1]['children'].each do |child|
      post['children'].push(child[0])
    end
  end
  if (category[1]['products'])
    post['products'] = Array.new
    category[1]['products'].each do |product|
      post['products'].push(product)
    end
  end

  # Save Index\
  file = heritage + '/index.html'
  puts file
  FileUtils.mkdir_p(File.dirname(file)) unless File.exists?(File.dirname(file))
  File.open(file, 'w+') do |file|
    file.puts post.to_yaml
    file.puts "---\n\n"
  end

  return post.to_yaml
end

def build_product_front_matter (product)
  post = Hash.new
  post['layout'] = 'product'
  post['title'] = product['product_name']
  post['sku'] = product['sku']
  post['lg_image'] = product['image_url']
  post['md_image'] = product['medium_image_url']
  post['sm_image'] = product['thumb_url']
  post['categories'] = Array.new
  post['categories'].push(normalize_category(seo_string(product['category'])))
  post['categories'].push(seo_string(product['subcategory']))
  post['categories'].push(seo_string(product['product_group']))
  if (product['long_description']) 
    post['description_list'] = build_description_list(product['long_description'])
  end
  if (product['keywords'] != nil) 
    post['tags'] = Array.new
    tags = product['keywords'].split(",")
    tags.each do |tag|
      post['tags'].push(seo_string(tag))
    end
  end
  if (product['retail_price'] == product['sale_price'])
    discount = ( (1+Random.rand(9).to_f) / 100 )
    you_save = product['retail_price'].to_f * discount
    you_save = you_save
    post['list_price'] = sprintf('%.2f', product['retail_price'].to_f + you_save.to_f)
    post['sale_price'] = sprintf('%.2f', product['sale_price'].to_f)
    post['you_save'] = sprintf('%.2f', you_save)
    post['discount'] = (discount*100).to_i
  end
  if (product['retail_price'].to_f > product['sale_price'].to_f)
    you_save = product['retail_price'].to_f - product['sale_price'].to_f
    post['list_price'] = sprintf('%.2f', product['retail_price'])
    post['sale_price'] = sprintf('%.2f', product['sale_price'])
    post['you_save'] = sprintf('%.2f', you_save)
    #post['discount'] = 00.00 #TODO
  end
  return post.to_yaml
end

def build_description_list (description)
    # Description
    description = description.gsub('fl.','fl').gsub('oz.','oz')
    @description = description.split('.')
    # Header & List
    description_header = ''
    description_list = '<ul class="description">'
    @description.each_with_index do |item, index|
      if (index == 0)
        description_header += "<h4>"+item+"</h4>"
      else
        description_list += "<li>"+item+"</li>"
      end
    end
    description_list += "</ul>"
    return description_header + description_list
end

def build_post_link (post, baseurl) 
      post_data = post.to_liquid
      #pp post_data
      link = "<a class=\"list-group-item\" href=\"" + baseurl + post_data['url'] + "\">"
      if (post_data['sale_price']) 
        link += "<span class=\"label label-success\">" + post_data['sale_price'] + "</span>&nbsp;"
      end
      link += post_data['title'] + "</a>\n"
end

def time_rand from = Time.now - (2*7*24*60*60), to = Time.now
  Time.at(from + rand * (to.to_f - from.to_f))
end

def seo_string (name)
  clean_name = name.gsub('/','-').gsub(' ','-').gsub('\'','').gsub('&-','').gsub(',','').gsub('(','').gsub(')','').gsub('----','-').gsub('---','-').gsub('--','-').gsub(':','')
  clean_name = clean_name.downcase
end

def titleize(string)
  string.split("-").map(&:capitalize).join(" ")
end

def normalize_category(category)
    category = 'kids' if category == 'kids-gear-and-clothing'
    category = 'womens' if category == 'womens-clothing'
    category = 'mens' if category == 'mens-clothing'
    category = 'snow' if category == 'skiing-and-snowboarding'
    return category
end

