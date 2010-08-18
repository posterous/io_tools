$(function(){
  
  var service = null;
  
  $('#service').change(function(){
    service = $(this).val();
    if (service != '') {
      $('.login_info').slideUp('medium',function(){
        $('#'+service).slideDown('medium');
      });
    }
  });
  $('.login_info').submit(function(e){
    e.preventDefault();
    $('#loading').show();
    $('#posts').html("");
    var params  = $('#'+service).serialize();
    $.post('/import', params ,function(data){
      $('#posts').html(data);
      $('#loading').hide();
    });
  });
});
