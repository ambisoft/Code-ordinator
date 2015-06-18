module ApplicationHelper

    def markdown(content)
        @markdown ||= Redcarpet::Markdown.new(Redcarpet::Render::HTML, autolink: true, strikethrough: true)
        @markdown.render(content).html_safe
    end

end
