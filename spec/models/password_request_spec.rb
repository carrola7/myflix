require 'spec_helper'

describe PasswordRequest do
  it { should validate_presence_of(:email) }
  it { should belong_to(:user)}
end