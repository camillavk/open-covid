# frozen_string_literal: true

class ProjectsController < ApplicationController
  before_action :load_project, only: [:show, :edit, :update]
  before_action :load_available_tags, only: [:index, :new, :edit]
  before_action :verify_email, only: :update

  def index
    @filters = filter_params[:tag_filters]
    @projects = !@filters.blank? ? filter_projects(@filters) : Project.all.sort_by(&:updated_at).reverse
    respond_to do |format|
      format.html
      format.js {render layout: false}
    end
  end

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

  def show; end

  def edit
    @tags = @project.tags
    @tag_values = @tags.map(&:name).join(", ")
  end

  def update
    add_tags_to_project
    if @project.update_attributes!(project_params)
      redirect_to @project
    end
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
    params.require(:project).permit(tag: [name: []])
  end

  def filter_params
    params.permit(:tag_filters)
  end

  def add_tags_to_project
    tags = tag_params[:tag][:name].first.split(",").each(&:strip!)

    tags.each do |tag|
      tag_already_present = @project.tags.map(&:name).any? { |s| s.casecmp(tag) == 0 }
      existing_tag = Tag.find_by(name: tag)
      if existing_tag && !tag_already_present
        @project.tags << existing_tag
        next
      end
      unless tag_already_present
        @project.tags.build(name: tag)
    end
    end
  end

  def load_project
    @project = Project.find(params[:id])
  end

  def load_available_tags
    @available_tags = Tag.all
  end

  def verify_email
    if @project.email != params[:project][:email] || params[:project][:email].blank?
      flash[:error] = "Incorrect email supplied."
      redirect_to edit_project_path(@project)
    end
  end

  def filter_projects(filters)
    tags = filters.split(",")
    projects = []

    tags.each do |tag|
      projects << Project.joins(:tags).where(tags: { name: "#{tag}" })
    end

    projects.flatten.sort_by(&:updated_at).reverse
  end
end
