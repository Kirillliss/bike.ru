module ApplicationHelper
  def image_sample_data
    "data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSIzMDAiIGhlaWdodD0iMjAwIj48cmVjdCB3aWR0aD0iMzAwIiBoZWlnaHQ9IjIwMCIgZmlsbD0iI2VlZSI+PC9yZWN0Pjx0ZXh0IHRleHQtYW5jaG9yPSJtaWRkbGUiIHg9IjE1MCIgeT0iMTAwIiBzdHlsZT0iZmlsbDojYWFhO2ZvbnQtd2VpZ2h0OmJvbGQ7Zm9udC1zaXplOjE5cHg7Zm9udC1mYW1pbHk6QXJpYWwsSGVsdmV0aWNhLHNhbnMtc2VyaWY7ZG9taW5hbnQtYmFzZWxpbmU6Y2VudHJhbCI+MzAweDIwMDwvdGV4dD48L3N2Zz4="
  end

  def hidden_div_if(condition, attributes = {}, &block)
    if condition
      attributes["style"] = "display: none"
    end
    content_tag("div", attributes, &block)
  end

  def category_menu_li(category)
    if category.children.any?
      content_tag :li do
        link_to category do
          category.title
        end
      end
    end
  end
  
  def nav_link(link_text, link_path, fontello = nil, options = {})
    class_name = current_page?(link_path) ? 'active' : ''
    i = ''
    i = "<i class='#{fontello}'></i>" if fontello
    "<li class='#{class_name}'>#{link_to [i, link_text].join(' ').html_safe, link_path, options}</li>".html_safe
  end
end
