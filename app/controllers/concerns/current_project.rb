module CurrentProject
  extend ActiveSupport::Concern

  private

    def current_project
      @current_project = Project.where(hostname: request.host).first_or_create
      @current_project.update(title: 'Default') if @current_project.title.blank?
      @current_project
    end
end