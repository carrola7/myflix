require 'spec_helper'

describe Invitation do
  it {should belong_to(:sender)}
  it {should belong_to(:receiver)}
  it {should validate_presence_of :name}
  it {should validate_presence_of :email}
  it {should validate_uniqueness_of :email}

  it_behaves_like "tokenable" do
    let(:model) { Fabricate(:invitation) }
  end
end