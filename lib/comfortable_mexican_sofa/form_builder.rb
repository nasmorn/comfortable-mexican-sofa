class ComfortableMexicanSofa::FormBuilder < BootstrapForm::FormBuilder
  def field_name_for(tag)
    tag.blockable.class.name.demodulize.underscore.gsub(/\//,'_')
  end

  def label_text_for(tag)
    I18n.t("admin.label.#{tag.blockable.class.name.underscore}.#{tag.identifier.to_s}", default: tag.identifier.to_s.humanize)
  end

  def add_help_text(tag, content)
    help_text = I18n.t("admin.help.#{tag.blockable.class.name.underscore}.#{tag.identifier.to_s}", default: "")
    content << content_tag(:p, help_text, class: "help-block") unless help_text.blank?    
  end

  # -- Tag Field Fields -----------------------------------------------------
  def default_tag_field(tag, index, method = :text_field_tag, options = {})
    label       = label_text_for(tag)
    content     = ''
    fieldname   = options.delete(:fieldname) || field_name_for(tag)

    case method
      when :file_field_tag
        content << @template.render(:partial => 'comfy/admin/cms/files/page_form', :locals => { :block => tag.block, :tag => tag, :field_name => "#{fieldname}[blocks_attributes][#{index}][content]" })
      else
        options[:class] = ' form-control'
        content << @template.send(method, "#{fieldname}[blocks_attributes][#{index}][content]", tag.content, options)
    end
    content << @template.hidden_field_tag("#{fieldname}[blocks_attributes][#{index}][identifier]", tag.identifier, :id => nil)

    add_help_text(tag, content)

    form_group :label => {:text => label } do
      content.html_safe
    end
  end

  def field_date_time(tag, index, fieldname = nil)
    default_tag_field(tag, index, :text_field_tag, :data => {'cms-datetime' => true}, fieldname: fieldname)
  end

  def field_integer(tag, index, fieldname = nil)
    default_tag_field(tag, index, :number_field_tag, fieldname: fieldname)
  end

  def field_string(tag, index, fieldname = nil)
    default_tag_field(tag, index, :text_field_tag, fieldname: fieldname)
  end

  def field_text(tag, index, fieldname = nil)
    default_tag_field(tag, index, :text_area_tag, :data => {'cms-cm-mode' => 'text/html'}, fieldname: fieldname)
  end

  def field_rich_text(tag, index, fieldname = nil)
    default_tag_field(tag, index, :text_area_tag, :data => {'cms-rich-text' => true}, fieldname: fieldname)
  end

  def field_boolean(tag, index)
    fieldname = field_name_for(tag)
    content = @template.hidden_field_tag("#{fieldname}[blocks_attributes][#{index}][content]", '', :id => nil)
    content << @template.check_box_tag("#{fieldname}[blocks_attributes][#{index}][content]", '1', tag.content.present?, :id => nil)
    content << @template.hidden_field_tag("#{fieldname}[blocks_attributes][#{index}][identifier]", tag.identifier, :id => nil)
    add_help_text(tag, content)
    form_group :label => {:text => label_text_for(tag)} do
      content
    end
  end

  def page_date_time(tag, index, fieldname = nil)
    default_tag_field(tag, index, :text_field_tag, :data => {'cms-datetime' => true}, fieldname: fieldname)
  end

  def page_integer(tag, index, fieldname = nil)
    default_tag_field(tag, index, :number_field_tag, fieldname: fieldname)
  end

  def page_string(tag, index, fieldname = nil)
    default_tag_field(tag, index, :text_field_tag, fieldname: fieldname)
  end

  def page_text(tag, index, fieldname = nil)
    default_tag_field(tag, index, :text_area_tag, :data => {'cms-cm-mode' => 'text/html'}, fieldname: fieldname)
  end

  def page_rich_text(tag, index, fieldname = nil)
    default_tag_field(tag, index, :text_area_tag, :data => {'cms-rich-text' => true}, fieldname: fieldname)
  end

  def page_file(tag, index, fieldname = nil)
    default_tag_field(tag, index, :file_field_tag, fieldname: fieldname)
  end

  def page_files(tag, index, fieldname = nil)
    default_tag_field(tag, index, :file_field_tag, :multiple => true, fieldname: fieldname)
  end

  def page_markdown(tag, index, fieldname = nil)
    default_tag_field(tag, index, :text_area_tag, :data => {'cms-cm-mode' => 'text/x-markdown'}, fieldname: fieldname)
  end

  def collection(tag, index, fieldname = nil)
    options = [["---- Select #{tag.collection_class.titleize} ----", nil]] +
      tag.collection_objects.collect do |m|
        [m.send(tag.collection_title), m.send(tag.collection_identifier)]
      end

    fieldname ||= field_name_for(tag)
    content = @template.select_tag(
      "#{fieldname}[blocks_attributes][#{index}][content]",
      @template.options_for_select(options, :selected => tag.content),
      :id => nil
    )
    content << @template.hidden_field_tag("#{fieldname}[blocks_attributes][#{index}][identifier]", tag.identifier, :id => nil)

    add_help_text(tag, content)
    form_group :label => {:text => label_text_for(tag)}, :class => tag.class.to_s.demodulize.underscore do
      content
    end
  end

  def page_section(tag, index, fieldname = nil)
    @template.render(:partial => 'comfy/admin/cms/pages/section', :object => tag)
  end

  # The tag just outputs the identifier of the snippet or page
  def page_identifier(tag, index, fieldname = nil)
    ""
  end

  def field_comment(tag, index, fieldname = nil)
    content_tag :h2, label_text_for(tag)
  end

end
