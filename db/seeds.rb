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

admin = User.create!(
  :name => 'Admin',
  :email => 'tylor@denimandsteel.com',
  :password => 'password',
  :password_confirmation => 'password'
)
admin.add_role :admin
PaperTrail.whodunnit = admin.id

regular = User.create!(
  :name => 'Regular',
  :email => 'tylor+regular@denimandsteel.com',
  :password => 'password',
  :password_confirmation => 'password'
)

animator = User.create!(
  :name => 'Animator',
  :email => 'tylor+animator@denimandsteel.com',
  :password => 'password',
  :password_confirmation => 'password'
)
animator.add_role :animator
PaperTrail.whodunnit = animator.id

pilot = Episode.create! :number => 1, :season => 1, :title => "Pilot"

  pilotSceneOne = pilot.scenes.create! :number => 1

    pilotSceneOne.assets.create!(
      :description => 'Clementine runs and jumps',
      :asset_type => 'character',
      :stock => true,
      :character_list => 'clementine',
      :keyword_list => 'jump',
      :asset => File.open(File.join(Rails.root, 'db', '20101123_BBA_Sig_Fresno_243.jpg'))
    )

  pilotSceneTwo = pilot.scenes.create! :number => 2

    pilotSceneTwo.assets.create!(
      :description => 'Bob moves around',
      :asset_type => 'character',
      :stock => true,
      :character_list => 'oliver',
      :keyword_list => '3/4 walk',
      :asset => File.open(File.join(Rails.root, 'db', '20100818_Scout_Schiphol_stills-081.jpg'))
    )

    pilotSceneTwo.assets.create!(
      :description => 'Cloud background',
      :asset_type => 'background',
      :stock => false,
      :keyword_list => 'cloud',
      :asset => File.open(File.join(Rails.root, 'db', 'clouds.mov'))
    )

finale = Episode.create! :number => 2, :season => 1, :title => "Finale"

  finaleSceneOne = finale.scenes.create! :number => 1

    finaleSceneOne.assets.create!(
      :description => 'Clementine skip and kicks', 
      :asset_type => 'character', 
      :stock => false,
      :character_list => 'clementine',
      :keyword_list => 'skip, kick', 
      :asset => File.open(File.join(Rails.root, 'db', '20111201-BBA-Boca-15127-04b.jpg'))
    )

  finaleSceneTwo = finale.scenes.create! :number => 2

    finaleSceneTwo.assets.create!(
      :description => 'Oliver gets booted', 
      :asset_type => 'character', 
      :character_list => 'oliver',
      :keyword_list => 'jump', 
      :asset => File.open(File.join(Rails.root, 'db', '20111202-BBA-Boca-15155-04a.jpg'))
    )

background = Asset.create!(
  :description => 'Desert background', 
  :asset_type => 'background', 
  :stock => true,
  :keyword_list => 'australia, dessert', 
  :asset => File.open(File.join(Rails.root, 'db', 'STK_BG_Australia_Dessert.fla'))
)

pilotSceneOne.assets << background
finaleSceneTwo.assets << background
