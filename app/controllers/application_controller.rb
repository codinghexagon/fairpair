# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?

  rescue_from ActiveRecord::RecordNotFound do
    flash[:notice] = 'Something went Wrong...'
    redirect_to root_url
  end

  rescue_from ActiveRecord::RecordNotDestroyed do
    flash[:notice] = 'Something went Wrong...'
    redirect_to root_url
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[email password password_confirmation user_name])
  end
end
