module PostsHelper
  def display_filter_select
    select('post', 'state', filter_options, { :include_blank => true }, { :remote => true, :class => 'styled-select'} )
  end
  
  def filter_options
    options_for_select (Post.state_machine.states.map { |p| [ p.name.capitalize, p.name, {:class => 'select_option'} ] }) #,
  end
end
