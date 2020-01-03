$(function () {

  // var file_field = document.querySelector('input[type=file]') //いったんコメントアウトしておきます

  function buildhtml(url){
    const html = `<div class="aaa">
    <img  src="${url}" width="114px" height="114px">
    <div class="ccc">
    <a id="photo_edit">編集</a>
    <a id="photo_delete">削除</a>
    </div>
    </div>`
    return html;
  }

 
//documentにする事で動的に追加された要素にもイベントを追加できます。
  $(document).on('change','.sell__upload__drop-file',(function (e) {
    e.preventDefault()
      // 画像の情報を取得
      console.log("okkkk")
      var file = this.files[0];
      //var file = e.target.files[0];
      //var url = window.URL.createObjectURL(file);

      var img_tag_id = $(this).data('imageTagId');
      // console.log(file)
      

      // 指定の拡張子以外の場合はアラート
      var permit_type = ['image/jpeg', 'image/png', 'image/gif'];
      if (file && permit_type.indexOf(file.type) == -1) {
          alert('この形式のファイルはアップロードできません');
          $(this).val('');
          $(img_tag_id).attr('src', '');
          return
      }

      // 読み込んだ画像を取得し、フォームの直後に表示させる
      var reader = new FileReader()
      reader.onload = function () {
         // $(img_tag_id).attr('src', reader.result);
         url = reader.result
         var html = buildhtml(url)
         $("#previews").append(html)
      }

      // 画像の読み込み
      reader.readAsDataURL(file);
  }));

  //画像を削除するイベント
  $(document).on('click', '#photo_delete', function() {
    // console.log("OK");
    //プレビューの要素を取得
    var target_photo = $(this).parent().parent();
    //プレビューを削除
    console.log(target_photo)
    target_photo.remove();
    //inputタグに入ったファイルを削除
    // file_field.val(""); //←この記述を書くとconsoleにエラーが生じるのでコメントアウトしておきます
  })
});



$(function(){
    //inputボタンが増殖する記述
  var input_area = $('.sell__container__form__upload__dropbox__have__box-size');

  $(document).on('change','#post_img,#post_img_last',function(event){
    var new_input = $('<input type="file" multiple="multiple" class="sell__upload__drop-file" name="item[images][]" id="post_img">');
    input_area.prepend(new_input);
  })

  // 一番新しいinputを押せるようにして古いinputは消す記述
  $(document).on('change', '#post_img,#post_img_last',function(event) {
    // 一番上のインプットだけ押せるように表示。
    $('.sell__container__form__upload__dropbox__have__box-size').children(":first").css({'display':'block'});
    // 選択したインプットは消す。
    $(this).css({'display':'none'});
  });
  
})



// const html = `<div class="item-image">
//                     <img  src="${url}" width="114px" height="114px">
//                     <div class="btn_wrapper">
//                       <label for="item_images_attributes_0_image">編集</label>
//                       <span class="js-remove">削除</span>
//                     </div>
//                   </div>`
//     return html;


// 下村商品画像削除を実装段階での記述を残しておきます
// $(function () {

//   // var file_field = document.querySelector('input[type=file]') //いったんコメントアウトしておきます

//   function buildhtml(url){
//     const html = `<div class="aaa">
//     <img  src="${url}" width="114px" height="114px">
//     <div class="ccc">
//     <a id="photo_edit">編集</a>
//     <a id="photo_delete">削除</a>
//     </div>
//     </div>`
//     return html;
//   }

//   $('.hidden').change(function (e) {
//     e.preventDefault()
//       // 画像の情報を取得
//       var file = this.files[0];
//       //var file = e.target.files[0];
//       //var url = window.URL.createObjectURL(file);

//       var img_tag_id = $(this).data('imageTagId');
//       // console.log(file)
      

//       // 指定の拡張子以外の場合はアラート
//       var permit_type = ['image/jpeg', 'image/png', 'image/gif'];
//       if (file && permit_type.indexOf(file.type) == -1) {
//           alert('この形式のファイルはアップロードできません');
//           $(this).val('');
//           $(img_tag_id).attr('src', '');
//           return
//       }

//       // 読み込んだ画像を取得し、フォームの直後に表示させる
//       var reader = new FileReader()
//       reader.onload = function () {
//          // $(img_tag_id).attr('src', reader.result);
//          url = reader.result
//          var html = buildhtml(url)
//          $(".previews").append(html)
//       }

//       // 画像の読み込み
//       reader.readAsDataURL(file);
//   });

//   //画像を削除するイベント
//   $(document).on('click', '#photo_delete', function() {
//     // console.log("OK");
//     //プレビューの要素を取得
//     var target_photo = $(this).parent().parent();
//     //プレビューを削除
//     target_photo.remove();
//     //inputタグに入ったファイルを削除
//     // file_field.val(""); //←この記述を書くとconsoleにエラーが生じるのでコメントアウトしておきます
//   })

// });