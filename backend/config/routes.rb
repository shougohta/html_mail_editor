Rails.application.routes.draw do
  # root "static#index"
  post 'mails/convert', to: 'mails#convert'
end
