Rails.application.routes.draw do
  scope "(:locale)", locale: /en|es|ja/ do
    root "archives#index"
    resources :archives
  end
end
