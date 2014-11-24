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
    shortlist,
    duplicate_swipebox_event;

duplicate_swipebox_event = false;
swiped_restaurant = true;
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
      if ($(".no_hover").length == 0){
        $(cards[current_card]).append("<div class='no_hover ui-icon-delete'><div class='cross'></div></div>");
      } else {
        $(".no_hover").css("opacity", e.throwOutConfidence * 2.5)
      }
    } else {
      if ($(".yes_hover").length == 0){
        $(cards[current_card]).append("<div class='yes_hover ui-icon-delete'><div class='star'></div></div>");
      } else {
        $(".yes_hover").css("opacity", e.throwOutConfidence * 2.5)
      }
    }
  })

  stack.on('throwin', function(e){
    $(".no_hover, .yes_hover").remove();

  })

  stack.on('throwout', function(e){
    successful_swipe = false;
    $(".no_hover, .yes_hover").remove();

    if (e.throwDirection === gajus.Swing.Card.DIRECTION_RIGHT){
      if (ever_yes || confirm("Swiping right will shortlist this restaurant. Are you sure?")){
        if (ever_yes == false){
          $.ajax({
            url: "/users/" + current_user_id, 
            type: 'POST',
            data: {user: {ever_swiped_yes: true }, _method:'PUT'},
            dataType: "json"
          });
          ever_yes = true;
        }
        $.ajax({
          url: "/dinder_searches/" + $(".container").attr("id") + "/shortlist", 
          type: 'POST',
          data: {restaurant_id: $(cards[current_card]).attr("id"), _method:'PUT'},
          dataType: "json"
        });    
        shortlist.push(cards[current_card]);
        $("#shortlist_count").html(shortlist.length);    
        successful_swipe = true;
        recordClick("Discarded Restaurant by " + (swiped_restaurant ? "SWIPE" : "CLICK"));
      }
    } else {
      if (ever_no || confirm("Swiping left will discard this restaurant. Are you sure?")){
        if (ever_no == false){
          $.ajax({
            url: "/users/" + current_user_id, 
            type: 'POST',
            data: {user: {ever_swiped_no: true }, _method:'PUT'},
            dataType: "json"
          });
          ever_no = true;
        }
        $.ajax({
          url: "/dinder_searches/" + $(".container").attr("id") + "/add_no", 
          type: 'POST',
          data: {restaurant_id: $(cards[current_card]).attr("id"), _method:'PUT'},
          dataType: "json"
        });
        successful_swipe = true;    
        recordClick("Shortlisted Restaurant by " + (swiped_restaurant ? "SWIPE" : "CLICK"));
      }
    }
    if (successful_swipe){
      current_card --;
      $(".call").attr("href", "tel:" + $(cards[current_card]).data("telephone"));
      $(".directions").attr("href", "https://maps.google.com/maps/place/" + $(cards[current_card]).data("address"));
      swiped_restaurant = true;
    } else {
      stack.getCard(cards[current_card]).throwIn(e.throwDirection, 0);
    }
  })

  $("#no_button").on("tap", function(e){
    swiped_restaurant = false;
    stack.getCard(cards[current_card]).throwOut(gajus.Swing.Card.DIRECTION_LEFT, 0);
    e.preventDefault();
  });

  $("#yes_button").on("tap", function(e){
    swiped_restaurant = false;
    stack.getCard(cards[current_card]).throwOut(gajus.Swing.Card.DIRECTION_RIGHT, 0);
    e.preventDefault();
  });

  $( '.swipebox' ).swipebox({
    afterClose: function(){
      if (duplicate_swipebox_event){
        recordClick("Close Photo gallery");
        duplicate_swipebox_event = false;
      } else {
        duplicate_swipebox_event = true;        
      }
    }
  });

  $(".call").on('click', function(){
    recordClick("Call");
  })
  $(".directions").on('click', function(){
    recordClick("Directions");
  })
  $(".photo_container > a").on('click', function(){
    recordClick("Photo zoom: photo_id = " + $(this).attr("id"))
  })
  $("#shortlist_count").on('click', function(){
    recordClick("Go to Shortlist");
  })
  $(".back_to_search").on('click', function(){
    recordClick("Back to Search")
  })

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


function recordClick(purpose){
  $.ajax({
    url: "/clicks", 
    type: 'POST',
    data: {click: {dinder_search_id: search_id, purpose: purpose, yelp_restaurant_id: $(cards[current_card]).attr("id")}},
    dataType: "json"
  });
}

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