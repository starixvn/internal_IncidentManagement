#custom routes for this plugin
get "favorite_projects/:action" => "favorite_projects"
get "favorite_projects/search" => "favorite_projects#searh", :as => "search_favorite_projects"
