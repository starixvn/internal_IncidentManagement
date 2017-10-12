require 'net/http'

module Letstalk
  module Hooks
    class ControllerLetstalkHook < Redmine::Hook::ViewListener

      def controller_issues_new_after_save(context={})
        send_message(context)
        #context[:issue].save
      end
      
      def controller_issues_edit_after_save(context={})        
        send_message(context)
        #context[:issue].save
      end
      
    private
      def send_message(context)
        params = context[:params]
        if params && params[:issue] && context[:issue] && context[:issue].id.present?
          
          if params[:chkLetstalk][:yesno_attribute] == 'yes'          
            uri = URI('http://61.14.176.37:801/api/IMMessage')
            res = Net::HTTP.post_form(uri, 'id' => context[:issue][:id].to_s, 'Comment' => context[:params][:txtletstalk], 'TargetName' => 'IMSP1TixUpdatesTarget')
            puts res.body
          end      
        end
      end

    end
  end
end