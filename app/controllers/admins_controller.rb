class AdminsController < AuthenticationsController
  before_filter :ensure_admin

  private

  def ensure_admin
    access_denied unless admin?
  end

  def admin?
    current_user.admin?
  end
end