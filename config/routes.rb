Rails.application.routes.draw do
  devise_for :users, path: '', path_names: {
                                 sign_in: 'login',
                                 sign_out: 'logout',
                                 registration: 'signup'
                               },
                     controllers: {
                       sessions: 'users/sessions',
                       registrations: 'users/registrations'
                     }

  resources :competitions, only: %i[create index show] do
    patch 'close', on: :member, to: 'competitions#close'
    post 'results', on: :member, to: 'results#create'
  end

  resources :modalities, only: %i[create index show]
end
