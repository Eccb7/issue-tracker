class IssuesController < ApplicationController
  # Set issue for actions that need a specific issue
  before_action :set_issue, only: %i[show edit update update_status destroy]
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

    # Handle form submission with 'new' value - convert to our valid 'new_issue' enum
    if params[:issue] && params[:issue][:status] == "new_issue"
      @issue.status = :new_issue
    end

    # Set default status if blank
    @issue.status = :new_issue if @issue.status.blank?

    # Set default priority if not provided
    @issue.priority = 3 if @issue.priority.blank?

    if @issue.save
      redirect_to @project, notice: "Issue was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # Update an existing issue
  def update
    # Handle 'new' status if it comes from an old form
    if params[:issue] && params[:issue][:status] == "new"
      params[:issue][:status] = "new_issue"
    end

    if @issue.update(issue_params)
      respond_to do |format|
        format.html { redirect_to @issue.project, notice: "Issue was successfully updated." }
        format.json { render json: { success: true, issue: @issue } }
        format.turbo_stream { flash.now[:notice] = "Issue was successfully updated." }
      end
    else
      respond_to do |format|
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: { success: false, errors: @issue.errors.full_messages }, status: :unprocessable_entity }
      end
    end
  end

  # Update only the status of an issue (used by kanban board)
  def update_status
    if @issue.update(status: params[:status])
      respond_to do |format|
        format.html { redirect_to kanban_project_path(@issue.project), notice: "Issue status updated." }
        format.json { render json: { success: true } }
      end
    else
      respond_to do |format|
        format.html { redirect_to kanban_project_path(@issue.project), alert: "Failed to update issue status." }
        format.json { render json: { success: false, errors: @issue.errors.full_messages }, status: :unprocessable_entity }
      end
    end
  end

  # Delete an issue
  def destroy
    project = @issue.project

    if @issue.destroy
      respond_to do |format|
        format.html { redirect_to project_path(project), notice: "Issue was successfully deleted." }
        format.json { head :no_content }
        format.turbo_stream { flash.now[:notice] = "Issue was successfully deleted." }
      end
    else
      respond_to do |format|
        format.html { redirect_to issue_path(@issue), alert: "Failed to delete issue: #{@issue.errors.full_messages.join(', ')}" }
        format.json { render json: @issue.errors, status: :unprocessable_entity }
        format.turbo_stream { flash.now[:alert] = "Failed to delete issue: #{@issue.errors.full_messages.join(', ')}" }
      end
    end
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
