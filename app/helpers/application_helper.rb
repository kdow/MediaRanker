module ApplicationHelper
  def readable_date(date)
    return "[unknown]" unless date
    return ("<span class='date' title='".html_safe +
            date.to_s +
            "'>".html_safe +
            date.strftime("%b %d, %Y") +
            "</span>".html_safe)
  end
end
