## ProjectsController: Handles CRUD operations for projects
class ProjectsController < ApplicationController
  # Set project for actions that need a specific project
  before_action :set_project, only: %i[show edit update destroy]

  # List all projects
  def index
    @projects = Project.all
  end

  # Show a single project and its issues
  def show
    @issues = @project.issues.order(created_at: :desc)
  end

  # Render form for new project
  def new
    @project = Project.new
  end

  # Render form for editing project
  def edit; end

  # Create a new project
  def create
    @project = Project.new(project_params)
    if @project.save
      redirect_to @project, notice: "Project was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # Update an existing project
  def update
    if @project.update(project_params)
      redirect_to @project, notice: "Project was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # Delete a project
  def destroy
    @project.destroy
    redirect_to projects_url, notice: "Project was successfully destroyed."
  end

  private

  # Find project by ID
  def set_project
    @project = Project.find(params[:id])
  end

  # Strong parameters for project
  def project_params
    params.require(:project).permit(:title, :description)
  end
end
