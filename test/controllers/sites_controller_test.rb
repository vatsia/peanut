require 'test_helper'

class SitesControllerTest < ActionController::TestCase
  test "should get server" do
    get :server
    assert_response :success
  end

end
