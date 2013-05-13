# encoding: utf-8

require 'carrierwave/processing/mini_magick'
class AssetUploader < CarrierWave::Uploader::Base

  # Include RMagick or MiniMagick support:
  # include CarrierWave::RMagick
  include CarrierWave::MiniMagick

  # Include the Sprockets helpers for Rails 3.1+ asset pipeline compatibility:
  # include Sprockets::Helpers::RailsHelper
  # include Sprockets::Helpers::IsolatedHelper

  IMAGE_EXTENSIONS = %w(jpg jpeg gif png)
  MOVIE_EXTENSIONS = %w(mov mp4)
  FLASH_EXTENSIONS = %w(fla flv swf)
  AUDIO_EXTENSIONS = %w(mp3 wav)
  
  # Choose what kind of storage to use for this uploader:
  #storage :file
  # storage :fog

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  def filename
    "#{version}_#{super}" if original_filename.present?
  end

  # Provide a default URL as a default if there hasn't been a file uploaded:
  # def default_url
  #   # For Rails 3.1+ asset pipeline compatibility:
  #   # asset_path("fallback/" + [version_name, "default.png"].compact.join('_'))
  #
  #   "/images/fallback/" + [version_name, "default.png"].compact.join('_')
  # end
 
  # def cache_dir
  #   "#{::Rails.root.to_s}/tmp/uploads" 
  # end
 
  def extension_white_list
    IMAGE_EXTENSIONS + MOVIE_EXTENSIONS + FLASH_EXTENSIONS + AUDIO_EXTENSIONS
  end
 
  # Create a new "process_extensions" method. It is like "process", except
  # it takes an array of extensions as the first parameter, and registers
  # a trampoline method which checks the extension before invocation.
  def self.process_extensions(*args)
    extensions = args.shift
    args.each do |arg|
      if arg.is_a?(Hash)
        arg.each do |method, args|
          processors.push([:process_trampoline, [extensions, method, args]])
        end
      else
        processors.push([:process_trampoline, [extensions, arg, []]])
      end
    end
  end
 
  # Our trampoline method which only performs processing if the extension matches.
  def process_trampoline(extensions, method, args)
    extension = File.extname(original_filename).downcase
    extension = extension[1..-1] if extension[0,1] == '.'
    self.send(method, *args) if extensions.include?(extension)
  end
  
  # Version actually defines a class method with the given block
  # therefore this code does not run in the context of an object instance  
  # and we cannot access uploader instance fields from this block.
  version :thumb do
    process_extensions AssetUploader::IMAGE_EXTENSIONS, resize_to_fill: [188, 106]
  end

  protected
  def version
    var = :"@#{mounted_as}_version"
    model.instance_variable_get(var) or model.instance_variable_set(var, model.versions.length)
  end
end
