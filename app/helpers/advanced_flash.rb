module AdvancedFlash
  
  DELETED_CREDENTIAL_FLASH = '_deleted_credential'
  DELETED_CREDENTIAL_SESSION_ID = :deleted_credential_id
  
  module ControllerSupport
    protected
    def add_deleted_credential_flash(deleted_credential)
      session[AdvancedFlash::DELETED_CREDENTIAL_SESSION_ID] = deleted_credential.id
      flash['deleted credential notice'] = AdvancedFlash::DELETED_CREDENTIAL_FLASH
    end
  end
  
  module Helper
    
    def render_flash
      return '' if flash.empty?
      content_tag :ul do
        flash.map do |k,v|
          content_tag :li, flash_content(v), :class => k
        end.join(' ')
      end
    end
    
    def flash_content(v)
      case v
      when DELETED_CREDENTIAL_FLASH
        deleted_credential_id = session.delete(AdvancedFlash::DELETED_CREDENTIAL_SESSION_ID)
        c = Credential::Archive.find_by_user_and_id!(current_user, deleted_credential_id)
        form = inline_button_to(undestroy_user_credential_path(:current, deleted_credential_id), :put, t('common.undo'))
        t("credentials.deleted", :provider => c.provider, :undo_link => form)
      else
        v
      end
    end
  
  end

end
