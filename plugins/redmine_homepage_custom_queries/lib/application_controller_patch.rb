require_dependency 'application_controller'
require_dependency 'issues_helper'
require_dependency 'queries_helper'

ApplicationController.send(:helper, IssuesHelper)
ApplicationController.send(:helper, QueriesHelper)