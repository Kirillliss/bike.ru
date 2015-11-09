# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

@category = Category.where(title: "Без категории").first_or_create
@category = Category.find(3)

if Product.count == 0
  p 'No products... Going create.'
  p "Product.count = #{Product.count}"
  100.times do |index|
    Product.create(title: "Ласты_#{index}", article: "76594#{index}", category_id: @category.id, published: true, price: Random.rand(300...300000))
  end
end
p "Product.count = #{Product.count}"