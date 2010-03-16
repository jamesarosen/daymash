module UsersHelper
  
  def credentials_list(user)
    content_tag(:ul, :class => 'credentials') do
      user.credentials.map do |c|
        content_tag(:li, :class => "credential #{c.provider}") do
          c.identifier
        end
      end.join(' ')
    end
  end
  
end
