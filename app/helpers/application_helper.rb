module ApplicationHelper

  def inline_edit(element, display, url, size, highlight, field)
    val  = "<span id=\"#{element}\">#{display}</span>\n"
    val += "<script type=\"text/javascript\">\n"
    val += "    new Ajax.InPlaceEditor('#{element}', '#{url}', {okControl:false, size:#{size}, highlightColor:\"#bbbbbb\", highlightEndColor:\"#{highlight}\", callback: function(form, value) { return 'field=#{field}&value='+encodeURIComponent(value)} });\n"
    val += "</script>\n"
  end

  def tag_list(kind)
    tags_of_kind = current_user.tags_for(kind) || []
    tags_of_kind.map! do |tag|
      link_to(tag, controller: kind.pluralize, tag: tag)
    end
    if (tags_of_kind.empty?)
      'tags: none'
    else
      raw("tags: #{tags_of_kind.join(', ')}")
    end
  end

  def tags_field(kind, desc_field=nil)
    tags_of_kind = current_user.tags_for(kind) || []
    val  = "<div class=\"form-group row\">"
    val += "    <div class=\"col-sm-12\">"
    val +=          select_tag :tag_list, options_for_select(tags_of_kind), include_blank: true, onchange: 'addTag()', class: 'form-control'
    val += "    </div>"
    val += "</div>"
    val += "<script type=\"text/javascript\">"
    val += "    function addTag() {"
    val += "        var sel_tag = $('#tag_list').val();"
    val += "        $('##{kind}_tags').val($('##{kind}_tags').val() + ' ' + sel_tag);"
    unless desc_field.blank?
      val += "        if ('' == $('##{desc_field}').val()) {"
      val += "            $('##{desc_field}').val(sel_tag);"
      val += "        }"
    end
    val += "    }"
    val += "</script>"
    raw val
  end

  def filters_links
    if params[:tag]
        "<small>filtered by:</small>
        <span class=\"filter\">
            #{params[:tag]}
            #{link_to('x', :action => :index)}
        </span>".html_safe
    end
  end

end
