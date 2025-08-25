Rails.application.routes.draw do
  # Health check
  get "up" => "rails/health#show", as: :rails_health_check

    # Root path
    patch "issues/:id/update_status", to: "issues#update_status", as: "update_issue_status"
  root "projects#index"

  # RESTful resources
  resources :projects do
    resources :issues, shallow: true
    member do
      get :kanban
    end
  end

  resources :issues, only: [ :index, :show, :new, :create, :edit, :update, :destroy ]

  resource :reports, only: :show do
    get :preview, on: :collection
    get "project/:id", to: "reports#project", as: :project
  end
end
