namespace :products do

  task create_root: :environment do
    category = Category.where(title: "Каталог").first_or_create
  end

  task randomize_frontpage: :environment do
    Product.update_all benefit: false
    prods = Product.imaged
    prods.update_all benefit: true

    Product.update_all hit: false
    prods = Product.imaged(4)
    prods.update_all hit: true

    Product.update_all markdown: false
    prods = Product.imaged(6)
    prods.update_all markdown: true

  end

  task fix_categories: :environment do
    category = Category.where(title: "Без категории").first_or_create
    puts "category: #{category.inspect}"
    puts "category.new_record? #{category.new_record?}"
    Product.all.each do |product|
      if product.category.nil?
        puts "Product category nil detected"
        product.category = category
        product.save
      end
    end
    puts "end"
  end
end