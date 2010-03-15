// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

jQuery(document).ready(function($) {
  DayMash.modalizeSignInAndSignUpLinks();
});

var DayMash = { 
  
  modalizeSignInAndSignUpLinks: function() {
    $('.sign_in a,.sign_up a').each(function() {
      $(this).addClass('rpxnow').click(function() {
        return false;
      });
    });
  }
  
};
