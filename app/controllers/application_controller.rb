class ApplicationController < ActionController::Base
  helper_method :current_user
  before_action :login_required
  before_action :set_locale

  private

  # ログインユーザを返却する
  def current_user
    @current_use ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end

  def login_required
    redirect_to login_path unless current_user
  end

  # i18n
  def set_locale
    I18n.l Time.now
    I18n.locale = current_user&.locale || :ja
  end
end
