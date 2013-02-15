module AssetsHelper
  def is_image(asset)
    extension = File.extname(asset.to_s).downcase
    extension = extension[1..-1] if extension[0,1] == '.'
    AssetUploader::IMAGE_EXTENSIONS.include?(extension)
  end

  def is_movie(asset)
    extension = File.extname(asset.to_s).downcase
    extension = extension[1..-1] if extension[0,1] == '.'
    AssetUploader::MOVIE_EXTENSIONS.include?(extension)
  end
end
