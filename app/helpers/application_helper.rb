module ApplicationHelper

  def datetime_format(datetime)
    return datetime.strftime("%d.%m.%Y %H:%M")
  end
end
