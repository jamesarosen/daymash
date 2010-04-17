module RpxHelper
  
  def rpx_scripts
    return <<-EOS
<script type="text/javascript">
  var rpxJsHost = (("https:" == document.location.protocol) ? "https://" : "http://static.");
  document.write(unescape("%3Cscript src='" + rpxJsHost +
"rpxnow.com/js/lib/rpx.js' type='text/javascript'%3E%3C/script%3E"));
</script>
<script type="text/javascript">
  RPXNOW.overlay = true;
  RPXNOW.language_preference = 'en';
</script>
EOS
  end
  
  def rpx_url(return_to)
    "https://daymash.rpxnow.com/openid/v2/signin?token_url=#{URI.encode return_to}"
  end
  
end
