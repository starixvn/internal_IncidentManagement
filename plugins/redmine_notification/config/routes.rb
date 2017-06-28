# Plugin's routes
# See: http://guides.rubyonrails.org/routing.html

get 'redmine_notification', :to => 'redmine_notification#index'
post 'redmine_notification/mark_viewed', :to => 'redmine_notification#mark_viewed'
put 'redmine_notification/mark_all_viewed', :to => 'redmine_notification#mark_all_viewed'

#match 'redmine_notification/mark_viewed', to: 'redmine_notification#mark_viewed', via: [:put]
