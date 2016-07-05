class CalendarInput < SimpleForm::Inputs::StringInput

  def input(wrapper_options)
    @input_type = 'text'
    " <div id=\"#{object_name}_#{attribute_name}\" class=\"input-append\">" +
          super +
    "     <span class=\"add-on\">" +
    "         <i data-time-icon=\"icon-time\" data-date-icon=\"icon-calendar\"></i>" +
    "     </span>" +
    " </div>".html_safe
  end
end
