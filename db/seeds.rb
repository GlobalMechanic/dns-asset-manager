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

episode = Episode.create! :number => 1, :season => 1, :title => "Pilot"
scene = episode.scenes.create! :number => 1

scene.assets.create! :description => 'Runs and jumps', :asset_type => 'character', :asset => File.open('/Users/tylor/Pictures/20101123_BBA_Sig_Fresno_243.jpg')
scene.assets.create! :description => 'Move things around', :asset_type => 'character', :asset => File.open('/Users/tylor/Pictures/20100818_Scout_Schiphol_stills-081.jpg')