Fabricator(:password_request) do
  email { Faker::Internet.email}
end