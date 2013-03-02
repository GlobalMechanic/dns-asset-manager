class Asset < ActiveRecord::Base
  TYPES = [
    ['Character', 'character'],
    ['Flora', 'flora'],
    ['Fauna', 'fauna'],
    ['Prop', 'prop'],
    ['Background', 'background'],
    ['Effect', 'effect'],
    ['Audio', 'audio'],
  ]

	has_paper_trail
  mount_uploader :asset, AssetUploader
  mount_uploader :preview, AssetUploader

  has_and_belongs_to_many :scene
  belongs_to :episode
  has_many :reel_assets, :dependent => :delete_all

  acts_as_taggable_on :keywords, :name

  attr_accessible :description,
                  :asset_type,
                  :name_list,
                  :keyword_list,
                  :asset,
                  :preview,
                  :episode_id,
                  :scene_ids,
                  :stock

  #before_create :parse_meta

  def parse_meta
    if self.asset?
      newAsset = File.basename(self.asset.to_s)
      leftover, filename, extension = newAsset.split(/^(.*)\.(.*)$/)
      elements = filename.split('_')

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

        self.id = elements.pop if elements[-1].match(/[0-9]/)
        self.asset_type = elements.shift if Asset::TYPES.map {|type| type[1] }.include?(elements[0])
        self.name_list = elements.shift
        self.keyword_list = elements.join(', ') if elements.length > 0
      end
    end
  end

  def title
    self.filename
  end

  def filename
    filename = []
    if self.stock?
      filename << 'STK'
    elsif self.scene_ids.length > 0
      Episode.joins(:scenes).where(:scenes => { :id => self.scene.map {|item| item.id} }).uniq.order("episodes.number ASC").each do |episode|
        filename << 'EP' + episode.number.pad
      end
    end
    filename += [self.asset_type] if self.asset_type
    filename += self.name_list.to_a + self.keyword_list.to_a + [self.id]
    puts filename.inspect
    filename = filename.join('_')
    filename += File.extname self.asset_url
    #filename.downcase
  end
end
