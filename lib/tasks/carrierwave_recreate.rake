namespace :carrierwave_recreate do

  task run: :environment do
    HomePageBanner.all.each do |banner|
      banner.image_big.recreate_versions! if banner.image_big?
      banner.image_small.recreate_versions! if banner.image_small?
    end
  end

end
