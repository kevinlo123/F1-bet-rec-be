# test/models/user_test.rb

require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test "should encrypt password" do
    user = User.new(email: "test@example.com", password: "password")
    user.save

    assert_not_nil user.password_digest
  end

  test "should authenticate with correct password" do
    user = User.create(email: "test@example.com", password: "password")
    
    assert user.authenticate("password")
  end

  test "should not authenticate with incorrect password" do
    user = User.create(email: "test@example.com", password: "password")
    
    assert_not user.authenticate("wrong_password")
  end
end