module ApplicationHelper
  def markdown_format(text)
    simple_format(text, {}, sanitize: false)
  end
end
