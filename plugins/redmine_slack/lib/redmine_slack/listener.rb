require 'httpclient'

module RedmineSlack
class Listener < Redmine::Hook::Listener
	def redmine_slack_issues_new_after_save(context = {})
		begin
			issue = context[:issue]
			return if issue.is_private?
			return unless issue.priority.position.in?([1, 2, 3])
			attachment = build_slack_attachment(issue)
			speak attachment
		rescue Exception => e
			handle_slack_exception(
			  client: HTTPClient.new,
			  exception: e,
			  params: { context: context },
			  context: "Hook#edit_after_save"
			)
		end
	end

	def redmine_slack_issues_edit_after_save(context = {})
		begin
			issue = context[:issue]
			journal = context[:journal]

			return if issue.is_private?
			return if journal.nil?

			# Don't change priority => return
			priority_changed = journal.details.any? { |d| d.prop_key == "priority_id" }
			return unless priority_changed

			old_priority_id = journal.details.find { |d| d.prop_key == "priority_id" }&.old_value&.to_i
			new_priority_id = issue.priority.id
			new_priority_position = issue.priority.position

			old_priority = IssuePriority.find_by(id: old_priority_id)
			old_priority_position = old_priority&.position

			return if old_priority_position.in?([1, 2, 3]) 
			return unless issue.priority.position.in?([1, 2, 3])

			attachment = build_slack_attachment(issue)
			speak attachment
		rescue Exception => e
			handle_slack_exception(
			  client: HTTPClient.new,
			  exception: e,
			  params: { context: context },
			  context: "Hook#edit_after_save"
			)
		end
	end

	def speak(params=nil)
		begin
			client = HTTPClient.new
			client.ssl_config.verify_mode = OpenSSL::SSL::VERIFY_NONE
			# client.ssl_config.cert_store.set_default_paths
			# client.ssl_config.ssl_version = :auto
			url_novaStar = "https://hooks.slack.com/services/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"
			url_private = "https://hooks.slack.com/services/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"
			url_plugin = Setting.plugin_redmine_slack['slack_url']
			url = url_plugin.presence || url_novaStar
			client.post_async  url_private, { payload: params.to_json }
			response = client.post url, { payload: params.to_json }
	
			if response.status != 200
				handle_slack_exception(
					client: client,
					exception: StandardError.new("Slack returned non-200 status"),
					params: {
						original_params: params,
						slack_response: response.body,
						status: response.status
					},
					context: "SlackNotification#speak #{response.status}"
				)
			end
		rescue Exception => e
			handle_slack_exception(
				client: client,
				exception: e,
				params: params,
				context: "SlackNotification#speak"
			)
		end
	end

private

	def handle_slack_exception(client:, exception:, params:, context: '')
		client.ssl_config.verify_mode = OpenSSL::SSL::VERIFY_NONE
		# client.ssl_config.cert_store.set_default_paths
		# client.ssl_config.ssl_version = :auto
		Rails.logger.warn("❌ #{context} Error: #{exception.class} - #{exception.message}")
		Rails.logger.warn(exception.backtrace.join("\n"))
		notify_url = "https://hooks.slack.com/services/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"
		error_payload = {
			text: "❌ Exception in #{context}: #{exception.class} - #{exception.message}",
			backtrace: exception.backtrace[0..5].join("\n"),
			original_params: params
		}
	
		begin
			client.post notify_url, { payload: error_payload.to_json }
		rescue => nested_e
			Rails.logger.warn("❌ Send Notification NovaStar: #{nested_e.class} - #{nested_e.message}")
		end
	end

	def escape(msg)
		msg.to_s.gsub("&", "&amp;").gsub("<", "&lt;").gsub(">", "&gt;")
	end

	def format_datetime(datetime_str)
		return 'N/A' if datetime_str.blank?
	
		begin
			dt = Time.parse(datetime_str)
			dt.strftime("%b %d, %Y %I:%M %p") # → "Mar 27, 2025 01:18 PM"
		rescue => e
			Rails.logger.warn("Failed to parse datetime: #{datetime_str} - #{e.message}")
			datetime_str # fallback to original
		end
	end

	def object_url(obj)
		if Setting.host_name.to_s =~ /\A(https?\:\/\/)?(.+?)(\:(\d+))?(\/.+)?\z/i
			host, port, prefix = $2, $4, $5
			Rails.application.routes.url_for(obj.event_url({
				:host => host,
				:protocol => Setting.protocol,
				:port => port,
				:script_name => prefix
			}))
		else
			Rails.application.routes.url_for(obj.event_url({
				:host => Setting.host_name,
				:protocol => Setting.protocol
			}))
		end
	end

	def url_for_project(proj)
		return nil if proj.blank?

		cf = ProjectCustomField.find_by_name("Slack URL")

		return [
			(proj.custom_value_for(cf).value rescue nil),
			(url_for_project proj.parent),
			Setting.plugin_redmine_slack['slack_url'],
		].find{|v| v.present?}
	end

	def channel_for_project(proj)
		return nil if proj.blank?

		cf = ProjectCustomField.find_by_name("Slack Channel")

		val = [
			(proj.custom_value_for(cf).value rescue nil),
			(channel_for_project proj.parent),
			Setting.plugin_redmine_slack['channel'],
		].find{|v| v.present?}

		# Channel name '-' is reserved for NOT notifying
		return nil if val.to_s == '-'
		val
	end

	def detail_to_field(detail)
		case detail.property
		when "cf"
			custom_field = detail.custom_field
			key = custom_field.name
			title = key
			value = (detail.value)? IssuesController.helpers.format_value(detail.value, custom_field) : ""
		when "attachment"
			key = "attachment"
			title = I18n.t :label_attachment
			value = escape detail.value.to_s
		else
			key = detail.prop_key.to_s.sub("_id", "")
			if key == "parent"
				title = I18n.t "field_#{key}_issue"
			else
				title = I18n.t "field_#{key}"
			end
			value = escape detail.value.to_s
		end

		short = true

		case key
		when "title", "subject", "description"
			short = false
		when "tracker"
			tracker = Tracker.find(detail.value) rescue nil
			value = escape tracker.to_s
		when "project"
			project = Project.find(detail.value) rescue nil
			value = escape project.to_s
		when "status"
			status = IssueStatus.find(detail.value) rescue nil
			value = escape status.to_s
		when "priority"
			priority = IssuePriority.find(detail.value) rescue nil
			value = escape priority.to_s
		when "category"
			category = IssueCategory.find(detail.value) rescue nil
			value = escape category.to_s
		when "assigned_to"
			user = User.find(detail.value) rescue nil
			value = escape user.to_s
		when "fixed_version"
			version = Version.find(detail.value) rescue nil
			value = escape version.to_s
		when "attachment"
			attachment = Attachment.find(detail.prop_key) rescue nil
			value = "<#{object_url attachment}|#{escape attachment.filename}>" if attachment
		when "parent"
			issue = Issue.find(detail.value) rescue nil
			value = "<#{object_url issue}|#{escape issue}>" if issue
		end

		value = "-" if value.empty?

		result = { :title => title, :value => value }
		result[:short] = true if short
		result
	end

	def mentions text
		return nil if text.nil?
		names = extract_usernames text
		names.present? ? "\nTo: " + names.join(', ') : nil
	end

	def extract_usernames text = ''
		if text.nil?
			text = ''
		end

		# slack usernames may only contain lowercase letters, numbers,
		# dashes and underscores and must start with a letter or number.
		text.scan(/@[a-z0-9][a-z0-9_\-\.]*/).uniq
	end

	def get_custom_field_value(issue, field_name)
		value = issue.custom_field_values.detect { |cf| cf.custom_field.name == field_name }&.value
		formatted = Array(value).join(', ')
		formatted.present? ? formatted : 'N/A'
	end

	def build_slack_attachment(issue)
		{
			"text": ":warning: Urgent Incident ##{issue.id}",
			"blocks": [
				{
					"type": "section",
					"text": {
						"type": "mrkdwn",
						"text": "*:warning: <#{object_url(issue)}|Urgent Incident ##{issue.id}>*"
					}
				},
				{
					"type": "section",
					"text": {
						"type": "mrkdwn",
						"text": [
							"*#{I18n.t('field_title')}:* #{escape(issue.subject.to_s)}",
							"*#{I18n.t('field_priority')}:* #{escape(issue.priority.to_s)}",
							"*#{I18n.t('field_assigned_to')}:* #{escape(issue.assigned_to.present? ? issue.assigned_to.to_s : '-')}",
							"*#{I18n.t('field_author')}:* #{escape(issue.author.to_s)}",
							"*Created DateTime (GMT+8):* #{format_datetime(escape(issue.created_on.to_s))}",
							"*Product:* #{escape(get_custom_field_value(issue, 'Product'))}",
							"*Related Site/System:* #{escape(get_custom_field_value(issue, 'Related Site/System'))}",
							"*Licensee:* #{escape(get_custom_field_value(issue, 'Licensee'))}"
						].join("\n")
					}
				},
				{
					"type": "divider"
				}
			]
		}
	end
end
end
