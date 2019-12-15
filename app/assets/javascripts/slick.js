$(function() {
  $('.slider').slick({
      prevArrow: '<img src="../assets/arrow-l.svg" class="slide-arrow prev-arrow">',
      nextArrow: '<img src="../assets/arrow-r.svg" class="slide-arrow next-arrow">',
      arrows: true,
      dots: true,
      autoplay: true,
      autoplaySpeed: 4000,
      speed: 800
  });

  $('.slick-dots li').on('mouseover', function() {
    $('.slider').slick('goTo', $(this).index());
  });
});