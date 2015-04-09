AaaStriping::Application.routes.draw do
  # public forms
  # match 'careers' => 'public/careers#new', :as => :new_career
  # match 'careers/create' => 'public/careers#create', :as => :create_career
  # match 'contact' => 'public/contacts#new', :as => :new_contact
  # match 'contact/create' => 'public/contacts#create', :as => :create_contact

  # private forms
  namespace :private, :path => 'admin' do
    resources :clients do
      resources :client_contacts
    end
    resources :completions
    resources :costs
    resources :crews do
      collection do
        get :calendar
      end
    end
    resources :estimates
    resources :equipments do
      get :delete_document, on: :member
    end

    resources :gun_sheets
    match 'private/gun_sheets/print_selected' => 'gun_sheets#print_selected', :as => :gun_sheets_print_selected
    resources :gun_marking_categories
    resources :jobs do
      get :delete_document, on: :member

      resources :comments
      resources :gun_sheets
      resources :job_sheets
      resources :material_reports
      resource :reconciliation_summary
      resource :material_report_summary
    end
    resources :job_sheets
    resources :load_sheets
    resources :manufacturers
    resources :material_reports
    resources :report_summaries, :only => [:index]
    resources :materials
    resources :time_sheets
    resources :daily_reports
    resources :time_note_categories
    resources :time_task_categories
    match 'archived_jobs' => 'jobs#archived_jobs', :as => :archived_jobs
    match 'private/material_reports/:id/update_dips' => 'material_reports#update_dips', :as => :update_dips
    match 'private/material_reports/:id/print' => 'material_reports#print', :as => :mat_print

    # clocking in and out
    match 'clock_in/:action/(:id)', :controller => 'clock_in'
    match 'clock_out/:action/(:id)', :controller => 'clock_out'
    resources :time_entries
  end

  namespace :api do
    resources :events do
      member do
        get :jobs
      end
    end
    resources :crews do
      collection do
        get :show_selected
        put :schedule_job
      end
      member do
        get :jobs
      end
    end
  end

  match '/admin' => 'private#index', :as => :private_home
  match '/admin/navigate' => 'private#navigate', :as => :private_navigate

  # reports
  match 'admin/reports/increase_offset/(:id)' => 'private/reports#increase_offset', :as => :report_increase_offset
  match 'admin/reports/decrease_offset/(:id)' => 'private/reports#decrease_offset', :as => :report_decrease_offset
  match 'admin/reports/reset_offset/(:id)' => 'private/reports#reset_offset', :as => :report_reset_offset
  match 'admin/reports/user_time/:id' => 'private/reports#user_time', :as => :report_user_time
  match 'admin/reports/crew_time/(:id)' => 'private/reports#crew_time', :as => :report_crew_time
  match 'admin/reports/time_entries/' => 'private/reports#time_entries', :as => :report_time_entries
  match 'admin/reports/accountant_csv' => 'private/reports#accountant_csv', :as => :export_accountant_csv
  match 'admin/reports/user_time_csv/:id' => 'private/reports#user_time_csv', :as => :export_user_time_csv
  match 'admin/reports/crew_time/:id/:date' => 'private/reports#set_date'
  match 'admin/reports/user_time/:id/:date' => 'private/reports#set_date'
  match 'admin/reports/time_entries/:date'  => 'private/reports#set_date'

  # summary reports
  match 'admin/report_summaries/all_job_value' => 'private/report_summaries#all_job_value', :as => :all_job_value
  match 'admin/report_summaries/all_marking_value' => 'private/report_summaries#all_marking_value', :as => :all_marking_value

  # user authentication and accounts
  resource :user_session
  resources :password_resets
  scope 'admin' do
    resources :users
  end

  match 'directory' => 'private/directory#index', :as => :directory, :path_prefix => 'admin'
  match 'register' => 'users#new', :as => :register
  match 'login' => 'user_sessions#new', :as => :login
  match 'logout' => 'user_sessions#destroy', :as => :logout

  # public content pages
  # match '/about' => 'public#about', :as => :about
  # match '/contacts' => 'public#contacts_redirect', :as => :contacts_redirect
  # match '/equipment-for-sale' => 'public#equipment_for_sale', :as => :equipment_for_sale
  # match '/products/plastiroute-mma-cold-plastic' => 'public#products_mma_cold_plastic', :as => :products_mma_cold_plastic
  # match '/products/plastiroute-aquaplast' => 'public#products_aquaplast', :as => :products_aquaplast
  # match '/products/cleanosol-thermoplastic' => 'public#products_cleanosol', :as => :products_cleanosol
  # match '/products/glass-bead' => 'public#products_glass_bead', :as => :products_glass_bead
  # match '/products' => 'public#products', :as => :products
  # match '/remove-paint-on-a-car' => 'public#remove_paint_on_a_car', :as => :remove_paint_on_a_car
  # match '/services' => 'public#services', :as => :services
  # match '/services/agglomerate' => 'public#services_aggolmerate', :as => :services_aggolmerate
  # match '/services/aquaflex-intermix' => 'public#services_aquaflex_intermix', :as => :services_aquaflex_intermix
  # match '/services/highway-beacon' => 'public#services_highway_beacon', :as => :services_highway_beacon
  # match '/services/hot-thermoplastic' => 'public#services_hot_thermoplastic', :as => :services_hot_thermoplastic
  # match '/services/line-painting' => 'public#services_line_painting', :as => :services_line_painting
  # match '/services/line-removal' => 'public#services_line_removal', :as => :services_line_removal
  # match '/services/mma-durables' => 'public#services_mma_durables', :as => :services_mma_durables
  # match '/services/seal-coating' => 'public#services_seal_coating', :as => :services_seal_coating
  # match '/services/parking-lot-maintenance' => 'public#services_parking_lot_maintenance', :as => :services_parking_lot
  # match '/suppliers' => 'public#suppliers', :as => :suppliers
  # match '/services/fast-dry-paint-with-the-twin-dry-system' => 'public#services_fast_dry_paint', :as => :services_fast_dry_paint
  # match '/thankyou' => 'public#thankyou', :as => :thankyou
  # match '/services/wet-night-visibility/agglomerate-structured-marking' => 'public#wet_night_aggolmerate', :as => :wet_night_aggolmerate
  # match '/services/wet-night-visibility/dotflex-mma-cold-plastic' => 'public#wet_night_dotflex', :as => :wet_night_dotflex
  # match '/services/wet-night-visibility/droponlinetm-hot-thermoplastic' => 'public#wet_night_droponlinetm', :as => :wet_night_droponlinetm

  root :to => redirect('/login')
end
