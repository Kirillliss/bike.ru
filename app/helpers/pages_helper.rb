module PagesHelper
  def display_pages(pages, current_page = nil)
    string ||= ""
    pages.each do |page|
      string += "<ul class='breadcrumb'>" if page.is_root?
      string += "<li class='#{'current' if (page == current_page) && (!page.is_root?)}'>"
      string += link_to(page.title, page, :class => "#{'current' if page == current_page}")
      string += "</ul>" if page.is_root?
      if page.has_children? && (page == current_page or page.descendants.include?(current_page))
        string += "<ul>"
        string += display_pages(page.children, current_page)
        string += '</ul>'
      end
      string += "</li>"
    end
    # string += '</ul>'
    string.html_safe
  end
end
