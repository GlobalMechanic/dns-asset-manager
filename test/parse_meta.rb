require "~/Sites/asset-manager/config/environment"
asset = Asset.new(
  :asset => File.open('/Users/tylor/Desktop/102_003.jpg'),
  :stock => true,
)
puts asset.inspect
asset.parse_meta
puts asset.inspect
puts "Names:"
puts asset.name_list
puts "Keywords:"
puts asset.keyword_list
