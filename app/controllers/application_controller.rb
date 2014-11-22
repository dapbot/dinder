class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_filter :authenticate_user!

  def authenticate_user!(*args)
    current_user.present? || super(*args)
  end
 
  def current_user
    super || User.find_or_initialize_by(token: anonymous_user_token).tap do |user|
      user.save(validate: false) if user.new_record?
      sign_in user
    end
  end
 
  private

  def anonymous_user_token
    cookies.permanent[:user_token] ||= SecureRandom.hex(8)
  end
end
