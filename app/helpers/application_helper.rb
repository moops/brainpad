# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  def show_image(src,w,h)
    img_options = { "src" => src.include?("/") ? src : "/images/#{src}" }
    img_options["src"] = img_options["src"] + ".png" unless
    img_options["src"].include?(".")
    img_options["border"] = "0"
    img_options["width"] = w if w != nil 
    tag("img", img_options)
  end
  
  def inline_edit(element, display, url, size, highlight, field)
    val = "<span id=\"#{element}\">#{display}</span>\n"
    val += "<script type=\"text/javascript\">\n"
    val += "    new Ajax.InPlaceEditor('#{element}', '#{url}', {okControl:false, size:#{size}, highlightColor:\"#bbbbbb\", highlightEndColor:\"#{highlight}\", callback: function(form, value) { return 'field=#{field}&value='+encodeURIComponent(value)} });\n"
    val += "</script>\n"
  end
  
end
