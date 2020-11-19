class Api::V1::UsersController < ActionController::API
    before_action :set_user, only: [:show, :update, :destroy]

# GET /user
  def index
    @user = User.all

    render json: @user
  end

  # PATCH/PUT /usuarios/1
  def update
    if @user.update(user_params)
      render json: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # DELETE /usuarios/1
  def destroy
    @user.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    def sign_in_params
        params.require(:user).permit(:email, :password, :admin)
    end
end

