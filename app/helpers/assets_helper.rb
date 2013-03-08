module AssetsHelper
  def is_image(asset)
    AssetUploader::IMAGE_EXTENSIONS.include?(clean_extension(asset))
  end

  def is_movie(asset)
    AssetUploader::MOVIE_EXTENSIONS.include?(clean_extension(asset))
  end

  def is_flash(asset)
    AssetUploader::FLASH_EXTENSIONS.include?(clean_extension(asset))
  end

  def is_audio(asset)
    AssetUploader::AUDIO_EXTENSIONS.include?(clean_extension(asset))
  end

  def previewable(asset)
    %w[jpg jpeg gif png swf].include?(clean_extension(asset))
  end

  def clean_extension(filename)
    extension = File.extname(filename.to_s).downcase
    extension = extension[1..-1] if extension[0,1] == '.'
  end
end
