class Api::V1::SessionsController < Devise::SessionsController
    before_action :sign_in_params, only: :create
    before_action :load_user, only: :create
    before_action :valid_token, only: :destroy
    skip_before_action :verify_signed_out_user, only: :destroy

    #Login
    def create
        if @user.valid_password?(sign_in_params[:password])
            sign_in "Usuário", @user
            json_response "Login realizado com sucesso", true, {user: @user}, :ok
        else
            json_response "Usuário não encontrado", false, {}, :unauthorized
        end
    end

    #Logout
    def destroy
        sign_out @user
        @user.generate_new_authentication_token
        json_response "Logout realizado com sucesso", true, {}, :ok
    end

    private
    def sign_in_params
        params.require(:sign_in).permit(:email, :password)
    end

    def load_user
        @user = User.find_for_database_authentication(email: sign_in_params[:email])

        if @user
            return @user
        else
            json_response "Usuário não encontrado", false, {}, :failure
        end
    end

    def valid_token
        @user = User.find_by authentication_token: request.headers["AUTH-TOKEN"]
        if @user
            return @user
        else
            json_response "Token inválido", false, {}, :failure
        end
    end
end