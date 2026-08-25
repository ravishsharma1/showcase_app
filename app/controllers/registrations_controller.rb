class RegistrationsController < Devise::RegistrationsController
  private

  def account_update_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :current_password)
  end

  # Prevent privilege escalation: only allow self-service roles, never admin.
  def sign_up_params
    permitted = params.require(:user).permit(:name, :email, :password, :password_confirmation)
    requested_role = params.dig(:user, :role)
    permitted[:role] = %w[user client].include?(requested_role) ? requested_role : "user"
    permitted
  end
end
