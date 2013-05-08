class Asset < ActiveRecord::Base
  TYPES = [
    ['Character', 'character'],
    ['Flora', 'flora'],
    ['Fauna', 'fauna'],
    ['Prop', 'prop'],
    ['Background', 'background'],
    ['Effect', 'effect'],
    ['Audio', 'audio'],
    ['Animatic', 'animatic'],
    ['Roughs', 'roughs'],
  ]

  STATUS = [
    ['Setup', 'setup'],
    ['Layout', 'layout'],
    ['Posing', 'posing'],
    ['Animation', 'animation'],
    ['Approved', 'approved'],
  ]

	has_paper_trail
  mount_uploader :asset, AssetUploader
  mount_uploader :preview, AssetUploader
  mount_uploader :preview_swf, AssetUploader

  has_and_belongs_to_many :scene
  belongs_to :episode
  belongs_to :user
  has_many :reel_assets, :dependent => :delete_all

  acts_as_taggable_on :keywords, :name

  attr_accessible :description,
                  :asset_type,
                  :name_list,
                  :keyword_list,
                  :asset,
                  :preview,
                  :preview_swf,
                  :episode_id,
                  :scene_ids,
                  :stock,
                  :status,
                  :submitted,
                  :approved,
                  :revision,
                  :checked_out,
                  :user_id,
                  :reuse

  # Parses filenames, like:
  # - stk_character_oliver_123.fla
  # - ep01_background_gabi_456.fla
  # - background_gabi_34run.fla
  # - (stk_|epN_)assetType_characterName_Keyword_Keyword.fla
  def parse_meta
    if self.asset?
      newAsset = File.basename(self.asset.to_s)
      leftover, filename, extension = newAsset.split(/^(.*)\.(.*)$/)
      elements = filename.split('_')

      if filename.match(/[0-9]{3}_[0-9]{3}/)
        leftover, season, episode, scene = filename.split(/([0-9]{1})([0-9]{2})_([0-9]{3})/)
        episode = Episode.find_by_season_and_number(season, episode)
        scene = Scene.find_or_create_by_number_and_episode_id(scene, episode.id)
        self.episode_id = episode.id
        self.scene << scene
      else
        if elements.length > 0 && animation = elements[0].downcase.match(/(stk|ep)([0-9]+)?/)
          case animation[1]
          when 'stk'
            self.stock = true            
          when 'ep'
            self.stock = false
            if episode = Episode.find_by_number(animation[2])
              self.episode_id = episode.id
            end
          end
          elements.shift # Strip off stock or episode
        end

        self.id = elements.pop if elements[-1].match(/^[0-9]+$/)
        self.asset_type = elements.shift.downcase if Asset::TYPES.map {|type| type[1] }.include?(elements[0].downcase)
        self.name_list.add(elements.shift) if elements.length > 0
        self.keyword_list.add(elements) if elements.length > 0
      end
    end
  end

  def title
    self.filename
  end

  def filename
    filename = []
    if self.scene_ids.length > 0
      filename << '1' + self.episode.number.pad
      self.scene.each do |scene|
          filename << scene.number.pad(3)
        end
    else
      if self.stock?
        filename << 'STK'
      elsif self.episode
        filename << self.episode.world.upcase
      end
      filename += [self.asset_type] if self.asset_type
      filename += self.name_list.to_a + [self.id]
    end
    #puts filename.inspect
    filename = filename.join('_')
    filename += File.extname self.asset_url
    #filename.downcase
  end
end
