module ApplicationHelper
  
  def inline_edit(element, display, url, size, highlight, field)
    val  = "<span id=\"#{element}\">#{display}</span>\n"
    val += "<script type=\"text/javascript\">\n"
    val += "    new Ajax.InPlaceEditor('#{element}', '#{url}', {okControl:false, size:#{size}, highlightColor:\"#bbbbbb\", highlightEndColor:\"#{highlight}\", callback: function(form, value) { return 'field=#{field}&value='+encodeURIComponent(value)} });\n"
    val += "</script>\n"
  end
  
  def tag_list(links, controller)
    links ||= []
    links.map! do |link|
      link_to(link, :controller => controller, :tag => link)
    end
    raw(links.join(', '))
  end
end
