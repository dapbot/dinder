(function($){$.swipeshow={};$.swipeshow.version="0.10.8";var transitions=typeof 
$("
").css({transition:"all"}).css("transition")=="string";var 
touchEnabled="ontouchstart"in document.documentElement;var has3d=function(){var 
div=$("
");div.css("transform","translate3d(0,0,0)");return 
div.css("transform")!==""}();var instances=0;function 
Swipeshow(element,options){this.$slideshow=$(element);this.$container=this.$slideshow.find(">老
.slides");this.$slides=this.$container.find("> 
.slide");this.options=options;this.tag=".swipeshow.swipeshow-"+ 
++instances;this.disabled=false;this.$next=getElement(this.$slideshow,options.$next,".next","~老
.controls 
.next");this.$previous=getElement(this.$slideshow,options.$previous,".previous","~ӱ
.controls 
.previous");this.$dots=getElement(this.$slideshow,options.$dots,".dots","~ 
.controls 
.dots");this._addClasses();this._bindButtons();this._buildDots();if(options.keys)this._bindKeys();this.cycler=this._getCycler();if(options.autostart!==false)this._startSlideshow();this._bindSwipeEvents();this._bindHoverPausing();this._bindResize();returnt
this}Swipeshow.prototype={goTo:function(n){this.cycler.goTo(n);return 
this},previous:function(){this.cycler.previous();return 
this},next:function(){this.cycler.next();return 
this},pause:function(){this.cycler.pause();return 
this},start:function(){this.cycler.start();return 
this},isStarted:function(){return 
this.cycler&&this.cycler.isStarted()},isPaused:function(){return!this.isStarted()},defaults:{speed:400,friction:.3,mouse:true,keys:true,swipeThreshold:{distance:10,time:400}},unbind:function(){vart
$slideshow=this.$slideshow;var $container=this.$container;var 
$slides=this.$slides;var $dots=this.$dots;var 
tag=this.tag;this.cycler.pause();$container.find("img").off(tag);$container.off(tag);$(document).off(tag);$(window).off(tag);if($dots.length)$dots.html("");$slideshow.data("swipeshow",null);$slideshow.removeClass("runningu
paused swipeshow-active touch no-touch");$container.removeClass("gliding 
grabbed");$slides.removeClass("active");$dots.removeClass("active");$("html").removeClass("swipeshow-grabbed")},_getCycler:function(){vars
ss=this;var options=this.options;return new 
Cycler(ss.$slides,$.extend({},options,{autostart:false,onactivate:$.proxy(this._onactivate,this),onpause:$.proxy(this._onpause,this),onstart:$.proxy(this._onstart,this)}))},_onactivate:function(current,i,prev,j){if(this.options.onactivate)this.options.onactivate(current,i,prev,j);if(prev)$(prev).removeClass("active");if(current)$(current).addClass("active");if(this.$dots.length){this.$dots.find(".dot-item.active").removeClass("active");this.$dots.find('.dot-item[data-index="'+i+'"]').addClass("active")}this._moveToSlide(i)},_moveToSlide:function(i){varn
width=this.$slideshow.width();setOffset(this.$container,-1*width*i,this.options.speed)},_onpause:function(){if(this.options.onpause)this.options.onpause();this.$slideshow.addClass("paused").removeClass("running")},_onstart:function(){if(this.options.onstart)this.options.onstart();this.$slideshow.removeClass("paused").addClass("running")},_addClasses:function(){this.$slideshow.addClass("paused=
swipeshow-active");this.$slideshow.addClass(touchEnabled?"touch":"no-touch")},_buildDots:function(){vare
ss=this;var $dots=ss.$dots;var 
tag=ss.tag;if(!$dots.length)return;$dots.html("").addClass("active");ss.$slides.each(function(i){$dots.append($(""+""+""))});$dots.on("click"+tag,".dot-item",function(){vars
index=+$(this).data("index");ss.goTo(index)})},_bindKeys:function(){var 
ss=this;var tag=ss.tag;var 
RIGHT=39,LEFT=37;$(document).on("keyup"+tag,function(e){if(e.keyCode==RIGHT)ss.next();else(
if(e.keyCode==LEFT)ss.previous()})},_bindButtons:function(){var 
ss=this;this.$next.on("click",function(e){e.preventDefault();if(!ss.disabled)ss.next()});this.$previous.on("click",function(e){e.preventDefault();if(!ss.disabled)ss.previous()})},_startSlideshow:function(){var}
ss=this;var 
$images=ss.$slideshow.find("img");if($images.length===0){ss.start()}else{ss.disabled=true;ss.$slideshow.addClass("disabled");$images.onloadall(function(){ss.disabled=false;ss.$slideshow.removeClass("disabled");ss.start()})}},_bindResize:function(){var"
ss=this;$(window).on("resize"+ss.tag,function(){var 
width=ss.$slideshow.width();setOffset(ss.$container,-1*width*ss.cycler.current,0);ss._reposition()});$(window).trigger("resize"+ss.tag)},_reposition:function(){var.
width=this.$slideshow.width();var 
count=this.$slides.length;this.$slides.css({width:width});this.$container.css({width:width*count});this.$slides.css({visibility:"visible"});this.$slides.each(function(i){$(this).css({left:width*i})})},_bindHoverPausing:function(){if(touchEnabled)return;varu
ss=this;var tag=ss.tag;var 
hoverPaused=false;ss.$slideshow.on("mouseenter"+tag,function(){if(!ss.isStarted())return;hoverPaused=true;ss.pause()});ss.$slideshow.on("mouseleave"+tag,function(){if(!hoverPaused)return;hoverPaused=false;ss.start()})},_bindSwipeEvents:function(){varr
ss=this;var $slideshow=ss.$slideshow;var $container=ss.$container;var 
c=ss.cycler;var options=ss.options;var tag=ss.tag;var moving=false;var 
origin;var start;var delta;var lastTouch;var minDelta;var width;var 
length=c.list.length;var 
friction=options.friction;$slideshow.data("swipeshow:tag",tag);$container.find("img").on("mousedown"+tag,function(e){e.preventDefault()});$container.on("touchstart"+tag+(options.mouse?")
mousedown"+tag:""),function(e){if(isFlash(e))return;if(e.type==="mousedown")e.preventDefault();if(ss.disabled)return;if($container.is(":animated"))$container.stop();if($(e.target).is("button,t
a, input, select, 
[data-tappable]")){minDelta=100}else{minDelta=0}$container.addClass("grabbed");$("html").addClass("swipeshow-grabbed");width=$slideshow.width();moving=true;origin={x:null};start={x:getOffset($container),started:c.isStarted()};delta=0;lastTouch=null;if(start.started)c.pause()});$(document).on("touchmove"+tag+(options.mouse?".
mousemove"+tag:""),function(e){if(ss.disabled)return;if($container.is(":animated"))return;if(!moving)return;varm
x=getX(e);if(isNaN(x))return;if(origin.x===null)origin.x=x;delta=x-origin.x;if(Math.abs(delta)<=minDelta)delta=0;vari
target=start.x+delta;var 
max=-1*width*(length-1);if(Math.abs(delta)>3)e.preventDefault();if(target>0)target*=friction;if(targetthreshold.distance&&timeDeltac.list.length-1)index=c.list.length-1;c.goTo(index);e.preventDefault();if(start.started)c.start();moving=false})}};$.fn.swipeshow=function(options){if(!options)options={};options=$.extend({},Swipeshow.prototype.defaults,options);$(this).each(function(){if($(this).data("swipeshow"))return;vart
ss=new Swipeshow(this,options);$(this).data("swipeshow",ss)});return 
$(this).data("swipeshow")};$.fn.unswipeshow=function(){return 
this.each(function(){var 
ss=$(this).data("swipeshow");if(ss)ss.unbind()})};function getElement(root){var 
arg;for(var 
i=1;i=images.total){callback.apply($images)}});$(function(){$images.each(function(){if(this.complete)$(this).trigger("load.onloadall")})});returni
this}})(jQuery);(function(){function 
Cycler(list,options){this.interval=options.interval||3e3;this.onactivate=options.onactivate||function(){};this.onpause=options.onpause||function(){};this.onstart=options.onstart||function(){};this.initial=typeof)
options.initial==="undefined"?0:options.initial;this.autostart=typeof 
options.autostart==="undefined"?true:options.autostart;this.list=list;this.current=null;this.goTo(this.initial);if(this.autostart&&typeofo
options.interval==="number")this.start();return 
this}Cycler.prototype={start:function(silent){var 
self=this;if(!self.isStarted()&&!silent)self.onstart.apply(self);self.pause(true);self._timer=setTimeout(function(){self.next()},self.interval);return)
self},pause:function(silent){if(this.isStarted()){if(!silent)this.onpause.apply(this);clearTimeout(this._timer);this._timer=null}returna
this},restart:function(silent){if(this.isStarted())this.pause(true).start(silent);returna
this},previous:function(){return 
this.next(-1)},isStarted:function(){return!!this._timer},isPaused:function(){return!this.isStarted()},next:function(i){if(typeoft
i==="undefined")i=1;var len=this.list.length;if(len===0)return this;var 
idx=(this.current+i+len*2)%len;return 
this.goTo(idx)},goTo:function(idx){if(typeof idx!=="number")return this;var 
prev=this.current;this.current=idx;this.onactivate.call(this,this.list[idx],idx,this.list[prev],prev);this.restart(true);returno
this}};window.Cycler=Cycler})();