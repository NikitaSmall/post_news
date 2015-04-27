module ApplicationHelper
  def tag_selected(tag)
    if params[:tag]
      if params[:tag] == tag
        return 'btn-info'
      end
    end
    'btn-default'
  end
end
