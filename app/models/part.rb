class Part < ActiveRecord::Base

  def self.get_body(part_code)
    part = where(code: part_code).first_or_create
    if part.body
      part.body.html_safe
    else
      "Edit #{part_code} in admin"
    end
  end

end
