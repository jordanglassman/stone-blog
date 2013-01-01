require 'test_helper'

class PostsControllerTest < ActionController::TestCase
  setup do
    @post = FactoryGirl.create(:post)
    @new_post = FactoryGirl.build(:post)
    @finalized_post = FactoryGirl.create(:finalized_post)
    @published_post = FactoryGirl.create(:published_post)
    @editor = FactoryGirl.create(:editor)
  end

  test "should get list of published posts when not signed in" do
    get :index
    assert_response :success
    assert_not_nil assigns(:posts)
    assert_equal assigns(:posts).count, Post.find_all_by_state('published').count
  end
  
  test "should get list of all posts by default when signed in" do
    sign_in @editor
    get :index
    assert_response :success
    assert_not_nil assigns(:posts)
    assert_equal assigns(:posts).count, Post.all.count
  end

  test "should get new" do
    sign_in @editor
    get :new
    assert_response :success
  end

  test "should create post as a draft" do
    sign_in @editor
    assert_difference('Post.count') do
      post :create, post: { body: @new_post.body, title: @new_post.title }
    end
  end

  test "should be possible to override friendly id with a custom url on finalize" do
    sign_in @editor
    post :create, finalize_draft: 'Finalize Draft', post: { body: @new_post.body, slug: 'custom-url', title: @new_post.title }
    assert_redirected_to '/posts/custom-url'
  end

  test "should be possible to override friendly id with a custom url on save draft" do
    sign_in @editor
    post :create, save_draft: 'Save Draft', post: { body: @new_post.body, slug: 'custom-url', title: @new_post.title }
    assert_redirected_to '/posts/custom-url/edit'
  end

  test "should redirect back to edit screen when new post saved as draft" do
    sign_in @editor
    post :create, post: { body: @new_post.body, title: @new_post.title }
    assert_redirected_to edit_post_path(assigns(:post))
  end

  test "should redirect to show when new post is finalized" do
    sign_in @editor
    post :create, finalize_draft: 'Finalize Draft', post: { body: @new_post.body, title: @new_post.title }
    assert_redirected_to post_path(assigns(:post))
  end

  test "should redirect to show when new post is published" do
    sign_in @editor
    post :create, publish_draft: 'Publish', post: { body: @new_post.body, title: @new_post.title }
    assert_redirected_to post_path(assigns(:post))
  end

  test "should update published_at when post is published as a new post" do
    sign_in @editor
    
    published_time = Time.zone.now
    Time.zone.stubs(:now).returns(published_time)
    
    post :create, publish_draft: 'Publish', post: { body: @new_post.body, slug: @new_post.slug, title: @new_post.title }
    @new_post = Post.last
    assert Post.last.published_at == Time.zone.now
  end

  test "should show post" do
    get :show, id: @post
    assert_response :success
  end

  test "should get edit" do
    sign_in @editor
    get :edit, id: @post
    assert_response :success
  end

  test "should redirect to show when updated post is finalized" do
    sign_in @editor
    put :update, id: @post, finalize_draft: 'Finalize Draft', post: { body: @post.body, title: @post.title }
    assert_redirected_to post_path(assigns(:post))
  end

  test "should redirect back to edit screen when updated post saved as draft" do
    sign_in @editor
    put :update, id: @post, save_draft: 'Save Draft', post: { body: @post.body, title: @post.title }
    assert_redirected_to edit_post_path(assigns(:post))
  end

  test "should destroy post" do
    sign_in @editor
    assert_difference('Post.count', -1) do
      delete :destroy, id: @post
    end

    assert_redirected_to posts_path
  end
  
  test 'should allow tossed transition to tossed from index when signed in' do
    sign_in @editor
    assert_difference('Post.find_all_by_state("tossed").count', 1) do
      put :update, id: @published_post, abandon_draft: 'Save Draft', post: { body: @published_post.body, title: @published_post.title }
    end
  end
  
end
