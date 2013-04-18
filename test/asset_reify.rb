require "~/Sites/asset-manager/config/environment"

Asset.all[-4].versions.each do |version|
  # puts version.object.gsub(/(AssetUploader::Uploader)[0-9]+/, '')
  if version.object != nil
    version.object = version.object.to_s.gsub(/AssetUploader::Uploader([0-9]+)/, '')
    # version.object = version.object.to_s
    # puts version.object.class
    asset = version.reify rescue nil
    puts 'cats'
    puts asset.asset
  end
end

# asset = Asset.new(
#   :asset => File.open('/Users/tylor/Desktop/Background_Oliver_34FrontRun_Ant.png'),
#   :stock => true,
# )
# puts asset.inspect
# asset.parse_meta
# puts asset.inspect
# puts "Names:"
# puts asset.name_list
# puts "Keywords:"
# puts asset.keyword_list
