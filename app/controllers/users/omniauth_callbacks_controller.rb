class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController

  def google_oauth2
      # You need to implement the method below in your model (e.g. app/models/user.rb)
      @user = User.from_omniauth(request.env["omniauth.auth"])
      logger.debug "DATA = #{@user}"
      if @user.persisted?
        flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => "Google"
        sign_in_and_redirect @user, :event => :authentication
      else
        session["devise.google_data"] = request.env["omniauth.auth"]
        redirect_to new_user_registration_url
      end
  end

  def github
      # You need to implement the method below in your model (e.g. app/models/user.rb)
      if request.env["omniauth.auth"].info["email"].nil? &&
         !request.env["omniauth.auth"].nil?
        user = User.where(:uid => request.env["omniauth.auth"].info["nickname"]).first

        unless user
          @user = User.new
          @user.password = Devise.friendly_token[0,20]
          @user.provider = "git"
          @user.uid = request.env["omniauth.auth"].info["nickname"]
          redirect_to users_get_email_path :password => Devise.friendly_token[0,20],
          :nickname => request.env["omniauth.auth"].info["nickname"] and return
        end
      end
      @user = User.from_omniauth_git(request.env["omniauth.auth"])
      logger.debug "DATA = #{@user}"
      if @user.persisted?
        flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => "Github"
        sign_in_and_redirect @user, :event => :authentication
      else
        #session["devise.github_data"] = request.env["omniauth.auth"]
        redirect_to new_user_registration_url
      end
  end
end
