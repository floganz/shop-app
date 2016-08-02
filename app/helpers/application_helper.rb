module ApplicationHelper
  def user_sign_in?
    !current_user.nil?
  end
end
