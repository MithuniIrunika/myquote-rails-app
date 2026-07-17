module ApplicationHelper
  def flash_class(key)
    case key.to_s
    when "notice", "success" then "alert alert-success"
    when "error", "alert"    then "alert alert-danger"
    else                          "alert alert-info"
    end
  end
end