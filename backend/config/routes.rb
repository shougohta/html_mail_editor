Rails.application.routes.draw do
  # root "static#index"
  post 'mails/create', to: 'mails#create'
end
