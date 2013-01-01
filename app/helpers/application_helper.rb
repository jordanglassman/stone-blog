module ApplicationHelper
  
  def conditional_notice
    if !notice.blank?
			raw('<p id="notice">' + notice + '</p>')
		end
  end
  
  def render_markdown marked_down_text
    markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML.new(:hard_wrap => true),
      :autolink => true, :space_after_headers => true)
    marked_down_text.nil? ? '' : raw(markdown.render marked_down_text)
  end
  
end
