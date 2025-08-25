
# Issue Tracker

A modern Rails-based issue tracking system for managing projects and their issues, with advanced reporting and export features.

## Features
- Create, edit, and delete projects
- Create, edit, and delete issues for projects
- View issues by project and status
- Generate and preview reports (HTML, PDF, Excel)
- Download reports for all issues or per project
- Responsive UI with Tailwind CSS
- Chart visualizations for reports (pie and column charts)
- Error handling for missing data and templates

## Setup
1. **Clone the repository**
	```bash
	git clone git@github.com:Eccb7/issue-tracker.git
	cd issue-tracker
	```
2. **Install dependencies**
	```bash
	bundle install
	npm i
	```
3. **Setup the database**
	```bash
	rails db:migrate
	rails db:seed
	```
4. **Start the server**
	```bash
	rails server
	```
5. **Access the app**
	Visit `http://localhost:3000`

## Usage
- Create projects and issues from the dashboard
- Access general reports at `/reports` (preview, download PDF/Excel)
- Access per-project reports from each project page (preview, download PDF/Excel)
- View issues by project, status, and priority

## Code Structure
- `app/models/` - ActiveRecord models for Project and Issue
- `app/controllers/` - Controllers for business logic and reporting
- `app/views/` - ERB templates for UI and reports
- `app/assets/` - CSS, JS, images
- `db/migrate/` - Database migrations

## Error Handling
- Handles missing project IDs and missing templates gracefully
- Validates required fields for issues and projects

## Contributing
Pull requests are welcome. For major changes, open an issue first to discuss what you would like to change.

## License
MIT
