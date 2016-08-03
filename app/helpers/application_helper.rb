module ApplicationHelper
  def user_sign_in?
    !current_user.nil?
  end

  def cp(path)
    "active" if current_page?(path)
  end
end
