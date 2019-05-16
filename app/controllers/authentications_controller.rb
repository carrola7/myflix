class AuthenticationsController < ApplicationController
  before_filter :ensure_logged_in
end