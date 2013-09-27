RailsApp::Application.routes.draw do
  resources :blog_users, :comments, :posts
end
