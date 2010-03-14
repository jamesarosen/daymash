class HTML5FormBuilder < Formtastic::SemanticFormBuilder
  
  
  def number_field(method, options = {})
    ::ActionView::Helpers::InstanceTag.new(object_name, method, @template, options.delete(:object)).to_input_field_tag('number', options)
  end
  
  def email_field(method, options = {})
    ::ActionView::Helpers::InstanceTag.new(object_name, method, @template, options.delete(:object)).to_input_field_tag('email', options)
  end

  def url_field(method, options = {})
    ::ActionView::Helpers::InstanceTag.new(object_name, method, @template, options.delete(:object)).to_input_field_tag('url', options)
  end

  protected

  def input_with_html5_required(method, options = {})
    options[:required] = method_required?(method) unless options.key?(:required)
    if options[:required]
      (options[:input_html] ||= {})[:required] = 'required'
    end
    input_without_html5_required(method, options)
  end

  alias_method_chain :input, :html5_required

  def numeric_input(method, options)
    basic_input_helper(:number_field, :numeric, method, options)
  end

  def email_input(method, options)
    basic_input_helper(:email_field, :string, method, options)
  end

  def url_input(method, options)
    basic_input_helper(:url_field, :string, method, options)
  end

end
