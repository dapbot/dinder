//= require jquery
//= require jquery.cookie

$(function(){
  $("#suburb_select").on("change", function(){
    $("form#restaurants_search").submit();
  })

});