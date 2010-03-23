module AdvancedFlash
  
  DELETED_CREDENTIAL_FLASH = '_deleted_credential'
  DELETED_CREDENTIAL_SESSION_ID = :deleted_credential_id
  
  DELETED_CALENDAR_FLASH = '_deleted_calendar'
  DELETED_CALENDAR_SESSION_ID = :deleted_calendar_id
  
  module ControllerSupport
    protected
    def add_deleted_credential_flash(deleted_credential)
      session[AdvancedFlash::DELETED_CREDENTIAL_SESSION_ID] = deleted_credential.id
      flash['deleted credential notice'] = AdvancedFlash::DELETED_CREDENTIAL_FLASH
    end
    def add_deleted_calendar_flash(deleted_calendar)
      session[AdvancedFlash::DELETED_CALENDAR_SESSION_ID] = deleted_calendar.id
      flash['deleted calendar notice'] = AdvancedFlash::DELETED_CALENDAR_FLASH
    end
  end
  
  module Helper
    
    def flash_to_html
      return '' if flash.empty?
      content_tag :ul, :id => 'flash' do
        flash.map do |k,v|
          content_tag(:li, flash_content(v), :class => k)
        end.join(' ')
      end
    end
    
    def flash_to_json
      returning(flash.each { |k,v| flash[k] = flash_content(v) }.to_json) do
        flash.clear
      end
    end
    
    def flash_content(v)
      content_tag(:span, flash_text(v))
    end
    
    def flash_text(v)
      case v
      when DELETED_CREDENTIAL_FLASH
        deleted_credential_id = session.delete(AdvancedFlash::DELETED_CREDENTIAL_SESSION_ID)
        c = Credential::Archive.find_by_user_and_id!(current_user, deleted_credential_id)
        form = inline_button_to(t('common.undo'), undestroy_user_credential_path(:current, deleted_credential_id), :put, :class => 'ajax')
        t("credentials.deleted", :provider => c.provider, :undo_link => form)
      when DELETED_CALENDAR_FLASH
        deleted_calendar_id = session.delete(AdvancedFlash::DELETED_CALENDAR_SESSION_ID)
        c = Calendar::Archive.find_by_user_and_id!(current_user, deleted_calendar_id)
        form = inline_button_to(t('common.undo'), undestroy_user_calendar_path(:current, deleted_calendar_id), :put, :class => 'ajax')
        t('calendars.deleted', :title => c.title, :undo_link => form)
      else
        v
      end
    end
  
  end

end
