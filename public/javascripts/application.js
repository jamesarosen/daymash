/*
  **********************************
  Rails + JQuery + AJAX Support:
  c.f. http://gist.github.com/110410
  **********************************
*/

  jQuery.ajaxSetup({
    'beforeSend': function(xhr) {
      xhr.setRequestHeader("Accept", "text/javascript");
    }
  });

  function _ajax_request(url, data, callback, type, method) {
      if (jQuery.isFunction(data)) {
          callback = data;
          data = {};
      }
      return jQuery.ajax({
          type: method,
          url: url,
          data: data,
          success: callback,
          dataType: type
          });
  }

  jQuery.extend({
    put: function(url, data, callback, type) {
      return _ajax_request(url, data, callback, type, 'PUT');
    },
    delete_: function(url, data, callback, type) {
      return _ajax_request(url, data, callback, type, 'DELETE');
    }
  });

  /*
  Submit a form with Ajax
  Use the class ajaxForm in your form declaration
  <% form_for @comment,:html => {:class => "ajaxForm"} do |f| -%>
  */
  jQuery.fn.submitWithAjax = function() {
    this.unbind('submit', false);
    this.submit(function() {
      $.post(this.action, $(this).serialize(), null, "script");
      return false;
    });
    return this;
  };

  /*
  Retreive a page with get
  Use the class get in your link declaration
  <%= link_to 'My link', my_path(),:class => "get" %>
  */
  jQuery.fn.getWithAjax = function() {
    this.unbind('click', false);
    this.click(function() {
      $.get($(this).attr("href"), $(this).serialize(), null, "script");
      return false;
    });
    return this;
  };

  /*
  Post data via html
  Use the class post in your link declaration
  <%= link_to 'My link', my_new_path(),:class => "post" %>
  */
  jQuery.fn.postWithAjax = function() {
    this.unbind('click', false);
    this.click(function() {
      $.post($(this).attr("href"), $(this).serialize(), null, "script");
      return false;
    });
    return this;
  };

  /*
  Update/Put data via html
  Use the class put in your link declaration
  <%= link_to 'My link', my_update_path(data),:class => "put",:method => :put %>
  */
  jQuery.fn.putWithAjax = function() {
    this.unbind('click', false);
    this.click(function() {
      $.put($(this).attr("href"), $(this).serialize(), null, "script");
      return false;
    });
    return this;
  };

  /*
  Delete data
  Use the class delete in your link declaration
  <%= link_to 'My link', my_destroy_path(data),:class => "delete",:method => :delete %>
  */
  jQuery.fn.deleteWithAjax = function() {
    this.removeAttr('onclick');
    this.unbind('click', false);
    this.click(function() {
      $.delete_($(this).attr("href"), $(this).serialize(), null, "script");
      return false;
    });
    return this;
  };

/*
  *****************
  On-document-ready
  *****************
*/

  jQuery(document).ready(function($) {
    DayMash.enableJSStyles();
    DayMash.enableCloseButtonsOnFlash();
    DayMash.modalizeSignInAndSignUpLinks();
    DayMash.addAuthenticityTokenIfNecessary();
    DayMash.ajaxifyLinks();
    DayMash.makeXShowOnHover('form.inline', 'ul.credentials li');
    DayMash.makeXShowOnHover('form.inline', 'ul.calendars li');
    DayMash.makeXShowOnHover('span + a', 'h2,h3,h4,h5,h6');
  });

/*
  ****************************************************************
  Custom functions, bound to the DayMash scope to avoid collisions
  ****************************************************************
*/

  var DayMash = {
  
    ajaxifyLinks: function() {
      $('form.ajax').submitWithAjax();
      $('a.get').getWithAjax();
      $('a.post').postWithAjax();
      $('a.put').putWithAjax();
      $('a.delete').deleteWithAjax();
    },
    
    addAuthenticityTokenIfNecessary: function() {
      // from http://gist.github.com/110410
      // All non-GET requests will add the authenticity token
      // if not already present in the data packet
      $(document).ajaxSend(function(event, request, settings) {
        if (typeof(DayMash.auth_token) == "undefined") { return; }
        // <acronym title="Internet Explorer 6">IE6</acronym> fix for http://dev.jquery.com/ticket/3155
        if (settings.type == 'GET' || settings.type == 'get') { return; }
        settings.data = settings.data || "";
        settings.data += (settings.data ? "&" : "") + DayMash.auth_token.name + '=' + encodeURIComponent(DayMash.auth_token.value);
      });
    },
  
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
    },
    
    // add the .js class to <body> to enable JS-specific styles
    enableJSStyles: function() {
      $('body').addClass('js');
    },
    
    // when called by any element within a Flash item,
    // hides that flash item.
    //
    // Returns false to prevent any links from being followed,
    // but does not explicitly stop the action.
    hideMyFlashItem: function() {
      $(this).parents('#flash li').slideUp(function() { $(this).remove(); });
      return false;
    },
    
    // Add 'X' buttons to Flash <li>s.
    // If +selector+ is given, add a close button to
    // it. Otherwise, add close buttons to all
    // elements matching "#flash li".
    enableCloseButtonsOnFlash: function(selector) {
      if (typeof(selector) === 'undefined') {
        selector = '#flash li';
      }
      $(selector).each(function() {
        var closeButton = $('<a href="#" class="close" onClick="$(this).parent().slideUp(); return false;">╳</a>').click(DayMash.hideMyFlashItem);
        $(this).append(closeButton);
      });
    },
    
    displayFlash: function(flash) {
      if ($('#flash').length == 0) { $('<ul id="flash" />').prependTo('#main'); }
      $.each(flash, function(key, message) {
        var li = $('<li class="' + key + '">' + message + '</li>');
        li.hide();
        DayMash.enableCloseButtonsOnFlash(li);
        li.appendTo('#flash').slideDown('default');
      });
    },
  
    updateAggregateUrl: function(newContent) {
      $('.calendar.aggregate')
        .highlightFade({color:'#ddd',speed:2000,iterator:'exponential'})
        .html(newContent);
    },
    
    deleteCredential: function(id) {
      $('#' + id).fadeIn(function() { $(this).remove(); });
    }
  
  };
