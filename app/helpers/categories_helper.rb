module CategoriesHelper
  def display_categories(categories, current_category = nil)
    # string = '<ul class="categories">'
    string ||= ""
    categories.each do |category|
      string += "<ul class='breadcrumb'>" if category.is_root?
      string += "<li class='#{'current' if (category == current_category) && (!category.is_root?)}'>"
      string += link_to(category.title, category, :class => "#{'current' if category == current_category}")
      string += "</ul>" if category.is_root?
      if category.children.published.any? && (category == current_category or  category.descendants.include?(current_category))
        string += "<ul>"
        string += display_categories(category.children.published, current_category)
        string += '</ul>'
      end
      string += "</li>"
    end
    # string += '</ul>'
    string.html_safe
  end
end
