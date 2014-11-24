class UsersController < ApplicationController
  before_action :set_user, only: [:update]

  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { render json: {status: "ok"}, status: :ok }
      else
        format.html { render :edit }
        format.json { render json: {status: "error"}, status: :unprocessable_entity }
      end
    end
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = current_user
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:ever_swiped_yes, :ever_swiped_no)
    end
end