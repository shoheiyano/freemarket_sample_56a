$(function(){

  $('.owl-dots .owl-dot:first-child').addClass('active');
  $('.owl-dots .owl-dot:first-child').css({'opacity':'1','pointer':'default'});

  $('.owl-dot').hover(function(){
    $('.active').css({'opacity':'','pointer':''});
    $('.active').removeClass('active');
    $(this).addClass('active');
    $(this).css({'opacity':'1','pointer':'default'});
    });
  

  $('.item-box__main__photo__owl-photo__top__active').slick({
    autoplay: false,
    autoplayspeed: 3000,
    arrows: false,
    dots: false,
    dotsClass: 'owl-dots',
    pauseOnDotsHover: true,
  infinite: true,
  });

  $('.owl-dot').on('mouseover', function(e){
    var $currTaget = $(e.currentTarget);
    index = $('.owl-dot').index(this);
    slickObj = $('.item-box__main__photo__owl-photo__top__active').slick('getSlick');
    slickObj.slickGoTo(index);
  });

  if($('.owl-dot').length > 4) {
    $('.owl-dot').css({'width':'56px','height':'56px'});
  }
});