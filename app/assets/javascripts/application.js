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
//= require jquery.mobile.overrides
//= require jquery.mobile
//= require swing.min
//= require jquery.swipebox.min
//= require_tree .

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
    config,
    current_card,
    shortlist;

shortlist = [];

config = {
  isThrowOut: function (offset, element, throwOutConfidence) {
    return throwOutConfidence > 0.5;
  }
}

$(function() {
  $("div.ui-page").css("min-height", window.outerHeight)
  
  $(".restaurant").css("height", $(".restaurant").width() + 30)

  $(".first_row").css("height", Math.floor($(".restaurant").width() * 2 / 3) - 2);

  $(".photo_container").each(function(){
    $(this).css("height", $(this).width());
  })
  // $(".photo_container").each(function(){
  //   if($(this).width() > $(this).children("img").first.width()){
  //     $(this).children("img").css("width", $(this).width())
  //   } else if($(this).height() > $(this).children("img").first.height()){
  //     $(this).children("img").css("height", $(this).height())
  //   }    
  // })
  // $(".extended").css("height", Math.min($(".image_4").height(), $(".image_5").height(), $(".image_6").height()));
  // if (window.resized_images == false){
  //   $(".first_row").css("height", $(".image_1").height());
  //   $(".extended").css("height", Math.min($(".image_4").height(), $(".image_5").height(), $(".image_6").height()));
  //   window.resized_images = true;
  //   alert("bang!");
  // }

  // Prepare the cards in the stack for iteration.
  cards = [].slice.call(document.querySelectorAll('div.container div.restaurant.stacked'))

  // An instance of the Stack is used to attach event listeners.
  stack = gajus.Swing.Stack(config);

  cards.forEach(function (targetElement) {
      // Add card element to the Stack.
      stack.createCard(targetElement);
  });

  current_card = cards.length - 1;

  // if(!window.pageYOffset){ hideAddressBar(); }

  stack.on('dragmove', function(e){


    if (e.throwDirection === gajus.Swing.Card.DIRECTION_LEFT){
      // $(".yes, .call, .directions").css("opacity", (1 - e.throwOutConfidence) )
      if ($(".no_hover").length == 0){
        $(cards[current_card]).append("<div class='no_hover ui-icon-delete'><div class='cross'></div></div>");
      } else {
        $(".no_hover").css("opacity", e.throwOutConfidence * 2.5)
      }
    } else {
      // $(".no, .call, .directions").css("opacity", (1 - e.throwOutConfidence) )    
      if ($(".yes_hover").length == 0){
        $(cards[current_card]).append("<div class='yes_hover ui-icon-delete'><div class='star'></div></div>");
      } else {
        $(".yes_hover").css("opacity", e.throwOutConfidence * 2.5)
      }
    }
  })
  stack.on('throwin', function(e){
    $(".no_hover, .yes_hover").remove();
    // $(".no, .yes, .call, .directions").css("opacity", 1  )    

  })
  stack.on('throwout', function(e){
    $(".no_hover, .yes_hover").remove();

    // $(".no, .yes, .call, .directions").css("opacity", 1  )    

    if (e.throwDirection === gajus.Swing.Card.DIRECTION_RIGHT){
      $.ajax({
        url: "/dinder_searches/" + $(".container").attr("id") + "/shortlist", 
        type: 'POST',
        data: {restaurant_id: $(cards[current_card]).attr("id"), _method:'PUT'},
        dataType: "json"
      });    
      shortlist.push(cards[current_card]);
      $("#shortlist_count").html(shortlist.length);
    } else {
      $.ajax({
        url: "/dinder_searches/" + $(".container").attr("id") + "/add_no", 
        type: 'POST',
        data: {restaurant_id: $(cards[current_card]).attr("id"), _method:'PUT'},
        dataType: "json"
      });    
    }
    current_card --;
    $(".call").attr("href", "tel:" + $(cards[current_card]).data("telephone"));
    $(".directions").attr("href", "https://maps.google.com?saddr=Current+Location&daddr=" + $(cards[current_card]).data("address"));
  })

  $("#no_button").on("tap", function(e){
    stack.getCard(cards[current_card]).throwOut(gajus.Swing.Card.DIRECTION_LEFT, 0);
    e.preventDefault();
  });

  $("#yes_button").on("tap", function(e){
    stack.getCard(cards[current_card]).throwOut(gajus.Swing.Card.DIRECTION_RIGHT, 0);
    e.preventDefault();
  });

  $( '.swipebox' ).swipebox();

});


// function hideAddressBar()
// {
//   if(!window.location.hash)
//   {
//       if(document.height < window.outerHeight)
//       {
//           document.body.style.height = (window.outerHeight + 200) + 'px';
//       }
 
//       setTimeout( function(){ window.scrollTo(0, 1); }, 50 );
//   }
// }
 
// window.addEventListener("orientationchange", hideAddressBar );


function OnImageLoad(evt) {

    var img = evt.currentTarget;
    console.log("image loaded: " + img)

    // what's the size of this image and it's parent
    var w = $(img).width();
    var h = $(img).height();
    var tw = $(img).parent().parent().width();
    var th = $(img).parent().parent().width();

    // compute the new size and offsets
    var result = ScaleImage(w, h, tw, th, false);

    // adjust the image coordinates and size
    $(img).css("width", result.width);
    $(img).css("height", result.height);
    $(img).css("left", result.targetleft);
    $(img).css("top", result.targettop);
}

function ScaleImage(srcwidth, srcheight, targetwidth, targetheight, fLetterBox) {

    var result = { width: 0, height: 0, fScaleToTargetWidth: true };

    if ((srcwidth <= 0) || (srcheight <= 0) || (targetwidth <= 0) || (targetheight <= 0)) {
        return result;
    }

    // scale to the target width
    var scaleX1 = targetwidth;
    var scaleY1 = (srcheight * targetwidth) / srcwidth;

    // scale to the target height
    var scaleX2 = (srcwidth * targetheight) / srcheight;
    var scaleY2 = targetheight;

    // now figure out which one we should use
    var fScaleOnWidth = (scaleX2 > targetwidth);
    if (fScaleOnWidth) {
        fScaleOnWidth = fLetterBox;
    }
    else {
       fScaleOnWidth = !fLetterBox;
    }

    if (fScaleOnWidth) {
        result.width = Math.floor(scaleX1);
        result.height = Math.floor(scaleY1);
        result.fScaleToTargetWidth = true;
    }
    else {
        result.width = Math.floor(scaleX2);
        result.height = Math.floor(scaleY2);
        result.fScaleToTargetWidth = false;
    }
    result.targetleft = Math.floor((targetwidth - result.width) / 2);
    result.targettop = Math.floor((targetheight - result.height) / 2);

    return result;
}