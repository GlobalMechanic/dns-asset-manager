# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Emanuel', :city => cities.first)
User.delete_all
Episode.delete_all
Scene.delete_all
Asset.delete_all
Version.delete_all
Reel.delete_all

user = User.create! :name => 'Admin', :email => 'tylor@denimandsteel.com', :password => 'password', :password_confirmation => 'password'
user.add_role :admin
PaperTrail.whodunnit = user.id

pilot = Episode.create! :number => 1, :season => 1, :title => "Pilot"
finale = Episode.create! :number => 2, :season => 1, :title => "Finale"

pilotSceneOne = pilot.scenes.create! :number => 1
pilotSceneTwo = pilot.scenes.create! :number => 2

finaleSceneOne = finale.scenes.create! :number => 1
finaleSceneTwo = finale.scenes.create! :number => 2

pilotSceneOne.assets.create! :description => 'Clementine runs and jumps', :asset_type => 'character', :keyword_list => 'clementine, jump', :asset => File.open(File.join(Rails.root, 'db', '20101123_BBA_Sig_Fresno_243.jpg'))
pilotSceneTwo.assets.create! :description => 'Bob move things around', :asset_type => 'character', :keyword_list => 'bob', :asset => File.open(File.join(Rails.root, 'db', '20100818_Scout_Schiphol_stills-081.jpg'))
pilotSceneTwo.assets.create! :description => 'Cloud background', :asset_type => 'background', :keyword_list => 'cloud', :asset => File.open(File.join(Rails.root, 'db', 'clouds.mov'))

finaleSceneOne.assets.create! :description => 'Clementine skip and kicks', :asset_type => 'character', :keyword_list => 'clementine', :asset => File.open(File.join(Rails.root, 'db', '20111201-BBA-Boca-15127-04b.jpg'))
finaleSceneTwo.assets.create! :description => 'Bob gets booted', :asset_type => 'character', :keyword_list => 'bob, jump', :asset => File.open(File.join(Rails.root, 'db', '20111202-BBA-Boca-15155-04a.jpg'))

background = Asset.create! :description => 'Desert background', :asset_type => 'background', :asset => File.open(File.join(Rails.root, 'db', 'tumblr_ll7wqijG8F1qz4m1bo1_1280.jpg'))

pilotSceneOne.assets << background
finaleSceneTwo.assets << background
