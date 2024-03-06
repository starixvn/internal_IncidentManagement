module NexcelImEnhanceIssuesHelper
    def render_half_width_custom_fields_rows_no_datetime_custom_field(issue)

        values = issue.visible_custom_field_values.reject {|value| value.custom_field.full_width_layout?}
        return if values.empty?
        half = ((values.size - 3) / 2.0).ceil
        issue_fields_rows do |rows|
            values.each_with_index do |value, i|
                css = "cf_#{value.custom_field.id}"
                m = (i < half ? :left : :right)
                rows.send m, custom_field_name_tag(value.custom_field), show_value(value), :class => css, :default_value => value.custom_field.default_value
            end
        end
    end
end

require 'issues_helper'
IssuesHelper.send(:include, NexcelImEnhanceIssuesHelper)