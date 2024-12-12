Rails.application.routes.draw do
  scope "(:locale)", locale: /en|es/ do
    root "archives#index"
    resources :archives
  end
end
