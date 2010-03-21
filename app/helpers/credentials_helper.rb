module CredentialsHelper
  
  def credentials_list(user)
    content_tag(:ul, :class => 'credentials') do
      has_multiple_credentials = (user.credentials.size > 1)
      user.credentials.map do |c|
        content_tag(:li, :class => "credential #{c.provider}") do
          content_tag(:span, c.provider, :title => c.identifier).tap do |content|
            content << ' ' + delete_credential_form(user, c) if has_multiple_credentials
          end
        end
      end.join(' ')
    end
  end
  
  def delete_credential_form(user, credential)
    inline_button_to user_credential_path(:current, credential), :delete, t('common.delete')
  end
  
end
