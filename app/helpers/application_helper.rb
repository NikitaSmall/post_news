module ApplicationHelper
  def tag_selected(tag)
    if params[:tag]
      if params[:tag] == tag
        return 'btn-info'
      end
    end
    'btn-default'
  end

  def size(index)
    num = index % 5
    return 'big' if num <= 2 && num != 0
    'small'
  end
end
