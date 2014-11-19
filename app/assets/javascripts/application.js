// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require twitter/bootstrap
//= require jquery.mobile
//= require swing.min
//= require imagesloaded.pkgd.min
//= require_tree .

window.resized_images = false;

function getGeoLocation() {
  navigator.geolocation.getCurrentPosition(setGeoCookie);
}

function setGeoCookie(position) {
  var cookie_val = position.coords.latitude + "|" + position.coords.longitude;
   var date = new Date();
	 var minutes = 10;
	 date.setTime(date.getTime() + (minutes * 60 * 1000));
  $.cookie("lat_lng", cookie_val, { expires: date, path: '/' });
	location.reload();
}

var stack,
    cards,
    config;

config = {
  isThrowOut: function (offset, element, throwOutConfidence) {
    return throwOutConfidence > 0.5;
  }
}

$(function() {
  if (window.screen.height > 550){
    $(".extended").css("display", "block");
  }

  // $(".first_row").css("height", $(".image_1").height());
  // $(".extended").css("height", Math.min($(".image_4").height(), $(".image_5").height(), $(".image_6").height()));
  // if (window.resized_images == false){
  //   $(".first_row").css("height", $(".image_1").height());
  //   $(".extended").css("height", Math.min($(".image_4").height(), $(".image_5").height(), $(".image_6").height()));
  //   window.resized_images = true;
  //   alert("bang!");
  // }

  // Prepare the cards in the stack for iteration.
  cards = [].slice.call(document.querySelectorAll('div.container div.restaurant'))

  // An instance of the Stack is used to attach event listeners.
  stack = gajus.Swing.Stack(config);

  cards.forEach(function (targetElement) {
      // Add card element to the Stack.
      stack.createCard(targetElement);
  });

});


function hideAddressBar()
{
  if(!window.location.hash)
  {
      if(document.height < window.outerHeight)
      {
          document.body.style.height = (window.outerHeight + 50) + 'px';
      }
 
      setTimeout( function(){ window.scrollTo(0, 1); }, 50 );
  }
}
 
window.addEventListener("load", function(){ if(!window.pageYOffset){ hideAddressBar(); } } );
window.addEventListener("orientationchange", hideAddressBar );


