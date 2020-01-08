


// $(function(){

// // ホバーするとビューを表示
//   $(".main-header-under__left__category").hover(
//     function(){
//       $('.parent-wrap').css({'display':'block'});
//       console.log("カテゴリが押された");
//     },
// //ホバーが外れるとビューを消す
//     function() {
//       $(".parent-wrap").css({'display':'none'});
//     console.log("hoverが外れたよ！");
//     });

// //---------------------------------------------------

// //childカテゴリを表示
//   $(".parent-wrap").hover(
//     function(){
//       $('.child-wrap').css({'display':'block'});
//       console.log("親が押された");
//     },
//   //ホバーが外れるとビューを消す
//     function() {
//       $(".child-wrap").css({'display':'none'});
//     });
// });

// //----------------------------------------------------

// //grand-childカテゴリを表示

//   $(".child-wrap").hover(
//     function(){
//       $('.grand-child-wrap').css({'display':'block'});
//       console.log("子が押された");
//     },
    
//   //ホバーが外れるとビューを消す
//     function() {
//       $(".grand-child-wrap").css({'display':'none'});
//     });



//     $(document).on('hover', '.child-wrap',function(event) {
//       $('.grand-child-wrap').css({'display':'block'});
//       console.log("子が押された");
//     });

//     $(function(){
//       $(".child-wrap").on({
//         'mouseenter' : function(){
//           $('.grand-child-wrap').css({'display':'block'});
//           console.log('のったよ！');
//         },
//         'mouseleave' : function(){
//           $(".grand-child-wrap").css({'display':'none'});
//           console.log('はなれたよ！');
//         },
//       });
//     })


$(document).ready(function(){

  $(".main-header-under__left__category").hover(function(){
    $(this).addClass('active');
    var parent = $('.active').children('.parent-wrap');
    parent.show();
  },function(){
    $(this).removeClass('active');
    $(this).children('.parent-wrap').hide();
  });


  $('.parent').hover(function(){
    $(this).addClass('active2');
    var Child = $('.active2').next('.child-wrap');
    Child.show();
  },function(){
    $(this).removeClass('active2');
    $(this).next('.child-wrap').css({"display":"none"});
  });






  
  // $('.child').hover(function(){
  //   $(this).addClass('active3');
  //   var Child = $('.active3').next('.grand-child-wrap');
  //   Child.show();
  // },function(){
  //   $(this).removeClass('active3');
  //   $(this).next('.grand-hild-wrap').hide();
  // });

});