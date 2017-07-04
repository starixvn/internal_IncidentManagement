# Plugin's routes
# See: http://guides.rubyonrails.org/routing.html

get 'redmine_notification', :to => 'redmine_notification#index'
match 'redmine_notification/mark_viewed', :to => 'redmine_notification#mark_viewed', :via => [:get, :post]
match 'redmine_notification/mark_all_viewed', :to => 'redmine_notification#mark_all_viewed', :via => [:put]
match 'redmine_notification/delete', :to => 'redmine_notification#delete', :via => :delete
match '/redmine_notification/diff/:id', :to => 'redmine_notification#diff', :id => /\d+/, :via => :get

#match 'redmine_notification/mark_viewed', to: 'redmine_notification#mark_viewed', via: [:put]
