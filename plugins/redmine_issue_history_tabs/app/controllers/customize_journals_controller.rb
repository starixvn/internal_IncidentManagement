class CustomizeJournalsController < ApplicationController
  unloadable
  
  before_filter :find_journal, :only => [:diff]
  menu_item :issues

  def diff
    @issue = @journal.issue
    if params[:detail_id].present?
      @detail = @journal.details.find_by_id(params[:detail_id])
    else
      @detail = @journal.details.detect {|d| d.prop_key == 'description'}
    end
    (render_404; return false) unless @issue && @detail
    @diff = DiffHelper.new(@detail.value, @detail.old_value)
    @detail
  end
  
  private

  def find_journal
    @journal = Journal.visible.find(params[:id])
    @project = @journal.journalized.project
  rescue ActiveRecord::RecordNotFound
    render_404
  end

end
