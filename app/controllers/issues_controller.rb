## IssuesController: Handles CRUD operations for issues within projects
class IssuesController < ApplicationController
  # Set issue for actions that need a specific issue
  before_action :set_issue, only: %i[show edit update destroy]
  # Set project for actions that need a specific project
  before_action :set_project, only: %i[new create]

  # Show a single issue
  def show; end

  # Render form for new issue
  def new
    @issue = @project.issues.build
  end

  # Render form for editing issue
  def edit; end

  # Create a new issue for a project
  def create
    @issue = @project.issues.build(issue_params)

    # Set default status if not provided
    @issue.status = 'pending' if @issue.status.blank?

    if @issue.save
      redirect_to @project, notice: "Issue was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # Update an existing issue
  def update
    if @issue.update(issue_params)
      redirect_to @issue.project, notice: "Issue was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # Delete an issue
  def destroy
    project = @issue.project
    @issue.destroy
    redirect_to project, notice: "Issue was successfully destroyed."
  end

  private

  # Find issue by ID
  def set_issue
    @issue = Issue.find(params[:id])
  end

  # Find project by project_id param
  def set_project
    @project = Project.find(params[:project_id])
  end

  # Strong parameters for issue
  def issue_params
    params.require(:issue).permit(:title, :description, :status, :priority)
  end
end
