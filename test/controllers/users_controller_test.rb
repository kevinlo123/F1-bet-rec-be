# test/controllers/users_controller_test.rb

require 'test_helper'
require 'jwt'

class UsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one) # Assuming you have fixture data for users
    @token = generate_token(user_id: @user.id)
  end

  test "should get index" do
    get users_url, headers: { 'Authorization' => "#{@token}" }, as: :json
    assert_response :success
  end

  test "should return users if any" do
    get users_url, headers: { 'Authorization' => "#{@token}" }, as: :json
    assert_includes response.body, @user.to_json
  end

  test "should create user" do
    assert_difference('User.count') do
      post users_url, params: { user: { email: "test@example.com", password: "password" } }, headers: { 'Authorization' => "#{@token}" }, as: :json
    end

    assert_response :created
  end

  test "should not create user with invalid params" do
    assert_no_difference('User.count') do
      post users_url, params: { user: { email: nil, password: nil } }, headers: { 'Authorization' => "#{@token}" }, as: :json
    end

    assert_response :unprocessable_entity
  end

  test "should show user" do
    get user_url(@user), headers: { 'Authorization' => "#{@token}" }, as: :json
    assert_response :success
  end

  test "should destroy user" do
    assert_difference('User.count', -1) do
      delete user_url(@user), headers: { 'Authorization' => "#{@token}" }, as: :json
    end

    assert_response :success
  end

  test "should update user" do
    patch user_url(@user), params: { user: { email: "new_email@example.com" } }, headers: { 'Authorization' => "#{@token}" }, as: :json
    assert_equal "new_email@example.com", @user.reload.email
    assert_response :success
  end

  private

  def generate_token(payload)
    secret_key = Rails.application.credentials.secret_key_base

    JWT.encode(payload, secret_key, 'HS256')
  end
end
