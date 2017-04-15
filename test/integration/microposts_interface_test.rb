require 'test_helper'

class MicropostsInterfaceTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:lauren)
  end

 
  test "micropost interface" do
    log_in_as(@user)
    get root_path
    assert_select 'input[type=file]'
    post microposts_path, micropost: { content: "" }
    assert_select 'div#error_explanation'
    content = "This micropost really ties the room together"
    picture = fixture_file_upload('test/fixtures/mayberrylogoo.jpg', 'image/jpg')
    assert_difference 'Micropost.count', 1 do
      post microposts_path, micropost: { content: content, picture: picture }
    end
    assert assigns(:micropost).picture?
    follow_redirect!
    assert_match content, response.body
    assert_select 'a', 'delete'
    first_micropost = @user.microposts.paginate(page: 1).first
    assert_difference 'Micropost.count', -1 do
      delete micropost_path(first_micropost)
    end
    get user_path(users(:allison))
    assert_select 'a', { text: 'delete', count: 0 }
  end
  
end