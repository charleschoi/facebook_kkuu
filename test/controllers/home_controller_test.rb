require 'test_helper'

class HomeControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get laugh" do
    get :laugh
    assert_response :success
  end

  test "should get sorrow" do
    get :sorrow
    assert_response :success
  end

end
