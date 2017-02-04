module ApplicationHelper

  def inline_edit(element, display, url, size, highlight, field)
    val  = "<span id=\"#{element}\">#{display}</span>\n"
    val += "<script type=\"text/javascript\">\n"
    val += "    new Ajax.InPlaceEditor('#{element}', '#{url}', {okControl:false, size:#{size}, highlightColor:\"#bbbbbb\", highlightEndColor:\"#{highlight}\", callback: function(form, value) { return 'field=#{field}&value='+encodeURIComponent(value)} });\n"
    val += "</script>\n"
  end

  def tag_list(kind)
    tags_of_kind = current_user ? current_user.tags_for(kind) : []
    tags_of_kind.map! do |tag|
      link_to(tag, "#{kind.pluralize}?tag=#{tag}")
    end
    if (tags_of_kind.empty?)
      'tags: none'
    else
      raw("tags: #{tags_of_kind.join(', ')}")
    end
  end

  def filters_links
    return unless params[:tag]
    "<small>filtered by:</small>
    <span class=\"filter\">
      #{params[:tag]}
      #{link_to('x', action: :index)}
    </span>".html_safe
  end

  def condense(content, max = 25)
    content ||= ''
    content.length > max ? "#{content[0,max]}..." : content
  end
end
