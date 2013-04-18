require "~/Sites/asset-manager/config/environment"
asset = Asset.new(
  :asset => File.open('/Users/tylor/Desktop/Background_Oliver_34FrontRun_Ant.png'),
  :stock => true,
)
puts asset.inspect
asset.parse_meta
puts asset.inspect
puts "Names:"
puts asset.name_list
puts "Keywords:"
puts asset.keyword_list
