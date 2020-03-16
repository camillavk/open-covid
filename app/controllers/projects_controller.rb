# frozen_string_literal: true

class ProjectsController < ApplicationController

  def index; end

  def new
    @project = Project.new
    @tags = @project.tags.build
  end

  def create
    @project = Project.new(project_params)
    add_tags_to_project
    if @project.save!
      redirect_to @project
    end
  end

  def show
    @project = Project.find(params[:id])
  end

  private

  def project_params
    params.require(:project).permit(:title,
                                    :short_description,
                                    :url,
                                    :description,
                                    :email)
  end

  def tag_params
    params.require(:project).permit(tag: [:name])
  end

  def add_tags_to_project
    tags = tag_params[:tag][:name].split(",")

    tags.each do |tag|
      @project.tags.build(name: tag)
    end
  end
end
