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
    
  def calendar(obj, attr, time=false, onupdate=nil)
    #http://www.dynarch.com/demos/jscalendar/doc/html/reference.html#node_sec_5.3.5
    size = time ? 19 : 12
    val = "<div>"
    val += text_field(obj, attr, :maxlength => 19, :size => size, :class => 'text') + "\n"
    val += "<img src=\"/images/calendar.png\"\n"
    val += "      id=\"#{obj}_#{attr}_tr\"\n"
    val += "      class=\"calIcon\"\n"
    val += "      title=\"date selector\"\n"
    val += "      onmouseover=\"this.style.background='red';\"\n"
    val += "      onmouseout=\"this.style.background=''\"/>\n"
    val += "<script type=\"text/javascript\">\n"
    val += "     Calendar.setup({\n"
    val += "      inputField     :    \"#{obj}_#{attr}\",\n"
    if time
      val += "      ifFormat       :    \"%b %e, %Y %H:%M\",\n"
      val += "      showsTime      :    \"true\",\n"
    else
      val += "      ifFormat       :    \"%b %e, %Y\",\n"
    end
    if onupdate
      val += "      onUpdate       :    #{onupdate},\n"
    end
    val += "      button         :    \"#{obj}_#{attr}_tr\",\n"
    val += "      weekNumbers    :    false,\n"
    val += "      cache          :    true\n"
    val += "      });\n"
    val += "</script>\n"
    val += "</div>\n"
  end
  
end
