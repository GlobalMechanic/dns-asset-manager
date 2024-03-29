task :gm => ["gm:clean", "gm:import"]

namespace :gm do
  task :import

  desc "Import the existing GM reels database"
  task :import => :environment do
    num = 0
    config =  ActiveRecord::Base.configurations["migration"]
    client = Mysql2::Client.new(config.symbolize_keys)
    clips = client.query("SELECT gm_clips.*, gm_categories.name_short AS category FROM gm_clips LEFT JOIN gm_categories ON gm_clips.category_id = gm_categories.id")
    clips.each do |clip|
      new_clip = Clip.new(
        :title => clip['clip_name'],
        :description => clip['clip_description'],
        :director => clip['clip_director'],
        # :director_url? - generate directly from clip_director
        :video => clip['clip_movies'],
        :image => clip['clip_thumbs'],
        :agency => clip['clip_agency'],
        :client => clip['clip_client'],
        :year => clip['clip_year'],
        :month => clip['clip_month'],
        :active => clip['clip_active'],
        :category => clip['category'],
        :legacy_id => clip['clip_id'],
      )
      # Can't mass assign tags in create, so break out:
      new_clip.keyword_list = clip['keywords']
      new_clip.technique_list = clip['clip_technique']
      new_clip.save

      puts num.to_s + ': ' + clip['clip_name']
      num += 1
    end
    puts "\nImported #{num} rows.\n\n"
  end

  desc "Clean out the GM reels frmo the current database"
  task :clean => :environment do
    num = Clip.delete_all
    puts "\nCleaned #{num} rows.\n\n"
  end

  desc "Test database conections"
  task :test => :environment do
    
  end

end
