desc 'Generate Recently Viewed Products Data'

task :related do

  puts "Generating Recently Viewed Products Data..."
  require 'rubygems'
  require 'jekyll'
  require 'yaml'
  require 'pp'
  include Jekyll::Filters
  
  options = Jekyll.configuration({})
  site = Jekyll::Site.new(options)
  site.read_posts('')

  relationships = Hash.new

  site.posts.each do |post|
  	post_data = post.to_liquid
  	pid = post_data['sku']
  	puts pid
  	relationships[pid] = Hash.new
		relationships[pid]['bought'] = Hash.new
		relationships[pid]['viewed'] = Hash.new
		relationships[pid]['together'] = Hash.new

  	primary_category = post.categories[0]
  	secondary_category = post.categories[1]

  	# Frequently Purchased Together
  	samples = site.categories[secondary_category].sample(2)
  	count = 0
  	max = 1
  	samples.each_with_index do |sample, i|
	  		sample_data = sample.to_liquid
	  		spid = sample_data['sku']
  		if count < max and spid != pid
	  		relationships[pid]['together'][spid] = Hash.new
	  		relationships[pid]['together'][spid]['title'] = sample_data['title']
	  		relationships[pid]['together'][spid]['sale_price'] = sample_data['sale_price']
	  		relationships[pid]['together'][spid]['url'] = sample_data['url']
  			count = count + 1
  		end
  	end

  	# People Also Viewed
  	samples = site.posts.sample(6)
  	count = 0
  	max = 4
  	samples.each_with_index do |sample, i|
	  		sample_data = sample.to_liquid
	  		spid = sample_data['sku']
  		if count < max and spid != pid and not relationships[pid]['together'][spid]
	  		relationships[pid]['viewed'][spid] = Hash.new
	  		relationships[pid]['viewed'][spid]['title'] = sample_data['title']
	  		relationships[pid]['viewed'][spid]['sale_price'] = sample_data['sale_price']
	  		relationships[pid]['viewed'][spid]['url'] = sample_data['url']
  			count = count + 1
  		end
  	end

  	# People Also Bought 
  	samples = site.categories[primary_category].sample(9)
  	count = 0
  	max = 4
  	samples.each_with_index do |sample, i|
	  		sample_data = sample.to_liquid
	  		spid = sample_data['sku']
  		if count < max and spid != pid and not relationships[pid]['together'][spid]
	  		relationships[pid]['bought'][spid] = Hash.new
	  		relationships[pid]['bought'][spid]['title'] = sample_data['title']
	  		relationships[pid]['bought'][spid]['sale_price'] = sample_data['sale_price']
	  		relationships[pid]['bought'][spid]['url'] = sample_data['url']
  			count = count + 1
  		end
  	end

  	#puts "\tbought: " + relationships[pid]['bought'].length.to_s 
  	#puts "\tviewed: " + relationships[pid]['viewed'].length.to_s 
  	#puts "\ttogether: " + relationships[pid]['together'].length.to_s 

	  # JSON Relationship Data
	  File.open("json/relationships/"+ pid +".json", 'w+') do |file|
	    file.puts relationships[pid].to_json()
	  end
  end

  # YAML Relationships Data
  File.open("_data/relationships.yml", 'w+') do |file|
    file.puts relationships.to_yaml(line_width: -1)
  end

  # JSON Relationships Data
  File.open("json/relationships.json", 'w+') do |file|
    file.puts relationships.to_json()
  end

  puts 'Done.'

end