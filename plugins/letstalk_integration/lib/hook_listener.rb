require 'net/http'
class Hooks < Redmine::Hook::ViewListener
  def view_letstalk_checkbox(context = {})
	letstalkCheckbox = check_box 'chkLetstalk','yesno_attribute', {}, 'yes', 'no'
	letstalkLabel = label_tag 'Letstalk'
    return content_tag("p",letstalkLabel + letstalkCheckbox, class: 'hidden lbl-letstalk-checkbox')
 end

  def view_letstalk_comment(context = {})
	letstalkLabel = label_tag 'Letstalk Comment'
	letstalkComment = text_area_tag 'txtletstalk', nil, rows: 3, cols: 90, placeholder: 'Enter your comment...'
    return content_tag("p", letstalkLabel + letstalkComment, class: 'hidden lbl-letstalk-comment')
  end

  def view_letstalk_include_javascript(context)
	javascript_include_tag(:application, :plugin => 'letstalk_integration')
  end

  def controller_letstalk_api(context= {})
	uri = URI('http://61.14.176.37:801/api/IMMessage')
	res = Net::HTTP.post_form(uri, 'id' => context[:issue][:id].to_s, 'Comment' => context[:params][:txtletstalk], 'TargetName' => 'IMSP1TixUpdatesTarget')
	puts res.body
  end

end