class UsersController < ApplicationController
  before_action :authenticate_user!, :except => [:get_email]
  before_action :set_user, :only => [:index]

  def index
    @orders = @user.history
  end

  def get_email
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(current_user.id)
    end
end
