module CredentialsHelper
  
  def credentials_list(user)
    content_tag(:ul, :class => 'credentials') do
      has_multiple_credentials = (user.credentials.size > 1)
      user.credentials.map do |c|
        credential_li user, c, has_multiple_credentials
      end.join(' ')
    end
  end
  
  def credential_li(user, credential, include_delete_form)
    content_tag(:li, :class => "credential #{credential.provider}", :id => credential.to_param) do
      content_tag(:span, credential.provider, :title => credential.identifier).tap do |content|
        content << ' ' + delete_credential_form(user, credential) if include_delete_form
      end
    end
  end
  
  def delete_credential_form(user, credential)
    inline_button_to t('common.delete'), user_credential_path(user, credential), :delete, :class => 'ajax'
  end
  
end
