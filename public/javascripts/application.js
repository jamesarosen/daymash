// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

jQuery(document).ready(function($) {
  DayMash.modalizeSignInAndSignUpLinks();
  DayMash.makeXShowOnHover('form.inline', 'ul.credentials li');
  DayMash.makeXShowOnHover('form.inline', 'ul.calendars li');
  DayMash.makeXShowOnHover('span + a', 'h2,h3,h4,h5,h6');
});

var DayMash = { 
  
  modalizeSignInAndSignUpLinks: function() {
    $('a.rpx, .sign_in a,.sign_up a').each(function() {
      $(this).addClass('rpxnow').click(function() {
        return false;
      });
    });
  },
  
  makeXShowOnHover: function(selector, scope) {
    $(selector, scope).hide();
    $(scope).hover(function() {
      $(selector, this).fadeIn('fast');
    }, function() {
      $(selector, this).fadeOut('fast');
    });
  }
  
};
