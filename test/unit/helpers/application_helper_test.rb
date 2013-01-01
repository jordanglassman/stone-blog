require 'test_helper'

class ApplicationHelperTest < ActionView::TestCase
  
  test 'render should behave sensibly if body is nil' do
    assert render_markdown nil
  end
  
  test 'render should behave sensibly if body is blank' do
    assert render_markdown ''
  end
  
end