function showmsg(s) {
  $('.flash-alert').html(s);
  $('.flash-container').fadeIn("slow", function() {
    setTimeout(function() {
      $('.flash-container').animate({height: '0px'}, 'slow', function() {
        $('.flash-alert').text('');
        $('.flash-container').hide();
      });
    }, 5000);
  });
}
