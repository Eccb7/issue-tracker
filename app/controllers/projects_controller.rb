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

    if @project.destroy
      respond_to do |format|
        format.html { redirect_to projects_url, notice: "Project was successfully deleted." }
        format.turbo_stream { flash.now[:notice] = "Project was successfully deleted." }
        format.json { head :no_content }
      end
    else
      respond_to do |format|
        format.html { redirect_to projects_url, alert: "Failed to delete project: #{@project.errors.full_messages.join(', ')}" }
        format.turbo_stream { flash.now[:alert] = "Failed to delete project: #{@project.errors.full_messages.join(', ')}" }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
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
