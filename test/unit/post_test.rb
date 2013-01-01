require 'test_helper'

class PostTest < ActiveSupport::TestCase
  
  test 'should generate a slug from the title' do
    post = FactoryGirl.create(:post)
    assert post.slug = post.title.gsub!(/ /, '-')
  end
  
  test 'should change the slug if a custom url is passed' do
    post = FactoryGirl.create(:post)
    new_slug = Faker::Lorem.words.join('-')
    post.update_attributes(slug: new_slug)
    assert post.slug = new_slug
  end
  
  # have not tested every possible state change here, but in a bigger app
  # that would probably be necessary
  test "should not be possible to finalize a published post" do
    published_post = FactoryGirl.create(:published_post)
    refute published_post.finalize
  end

  test "should not be possible to finalize a tossed post" do
    tossed_post = FactoryGirl.create(:tossed_post)
    refute tossed_post.finalize
  end
  
  test "should not be possible to save a finalized draft" do
    finalized_post = FactoryGirl.create(:finalized_post)
    refute finalized_post.save_draft
  end

  test "should not be possible to save a published post" do
    published_post = FactoryGirl.create(:published_post)
    refute published_post.save_draft
  end
  
end
