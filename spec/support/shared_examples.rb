shared_examples "requires_signed_in_user" do
  it "redirects to the sign in page" do
    clear_current_user
    action
    expect(response).to redirect_to login_path
  end
end