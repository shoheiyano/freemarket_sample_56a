$(function(){
  //DataTransferオブジェクトで、データを格納する箱を作る
  var dataBox = new DataTransfer();
  //querySelectorでfile_fieldを取得
  var file_field = document.querySelector('input[type=file]')
  //fileが選択された時に発火するイベント
  $(document).on('change','.sell__upload__drop-file',(function(e){

    //選択したfileのオブジェクトをpropで取得
    var files = $('input[type="file"]').prop('files')[0];
    $.each(this.files, function(i, file){
      //FileReaderのreadAsDataURLで指定したFileオブジェクトを読み込む
      var fileReader = new FileReader();

      //DataTransferオブジェクトに対して、fileを追加
      dataBox.items.add(file)
      //DataTransferオブジェクトに入ったfile一覧をfile_fieldの中に代入
      file_field.files = dataBox.files

      var num = $('.item-image').length + 1 + i
      fileReader.readAsDataURL(file);
      //画像が10枚になったら超えたらドロップボックスを削除する
      if (num == 10){
        $('#image-box__container').css('display', 'none')   
      }
      //読み込みが完了すると、srcにfileのURLを格納
      fileReader.onloadend = function() {
        var src = fileReader.result
        var html= `<div class='item-image' data-image="${file.name}">
                    <div class=' item-image__content'>
                      <div class='item-image__content--icon'>
                        <img src=${src} width="116" height="116" >
                      </div>
                    </div>
                    <div class='item-image__operetion'>
                      <div class='item-image__operetion--edit'>編集</div>
                      <div class='item-image__operetion--delete'>削除</div>
                    </div>
                  </div>`
        //image_box__container要素の前にhtmlを差し込む
        $('#image-box__container').before(html);
      };
      //image-box__containerのクラスを変更し、CSSでドロップボックスの大きさを変えてやる。
      $('#image-box__container').attr('class', `item-num-${num}`)
    });
  }));
  //削除ボタンをクリックすると発火するイベント
  //削除ボタンをクリックすると発火するイベント
$(document).on("click", '.item-image__operetion--delete', function(){
  //削除を押されたプレビュー要素を取得
  var target_image = $(this).parent().parent()
  //削除を押されたプレビューimageのfile名を取得
  var target_name = $(target_image).data('image')
  //プレビューがひとつだけの場合、file_fieldをクリア
  if(file_field.files.length==1){
    //inputタグに入ったファイルを削除
    $('input[type=file]').val(null)
    dataBox.clearData();
    console.log(dataBox)
  }else{
    //プレビューが複数の場合
    $.each(file_field.files, function(i,input){
      //削除を押された要素と一致した時、index番号に基づいてdataBoxに格納された要素を削除する
      if(input.name==target_name){
        dataBox.items.remove(i) 
      }
    })
    //DataTransferオブジェクトに入ったfile一覧をfile_fieldの中に再度代入
    file_field.files = dataBox.files
  }
  //プレビューを削除
  target_image.remove()
  //image-box__containerクラスをもつdivタグのクラスを削除のたびに変更
  var num = $('.item-image').length
  $('#image-box__container').show()
  $('#image-box__container').attr('class', `item-num-${num}`)
})




});



$(function(){
    //inputボタンが増殖する記述
  var input_area = $('.input-area');

  $(document).on('change','#post_img,#post_img_last',function(event){
    var new_input = $('<input type="file" multiple="multiple" class="sell__upload__drop-file" name="item[images][]" id="post_img">');
    input_area.prepend(new_input);
  })

  // 一番新しいinputを押せるようにして古いinputは消す記述
  $(document).on('change', '#post_img,#post_img_last',function(event) {
    // 一番上のインプットだけ押せるように表示。
    $('.input-area').children(":first").css({'display':'block','opacity': '0'});
    // 選択したインプットは消す。

    $('#post_img').css({'display':'none'});
  });
  
})







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

 
// //documentにする事で動的に追加された要素にもイベントを追加できます。
//   $(document).on('change','.sell__upload__drop-file',(function (e) {
//     e.preventDefault()
//       // 画像の情報を取得
//       console.log("okkkk")
//       var file = this.files[0];
//       var img_tag_id = $(this).data('imageTagId');
      

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
//          url = reader.result
//          var html = buildhtml(url)
//          $("#image-box__container").before(html)
//       }

//       // 画像の読み込み
//       reader.readAsDataURL(file);
//   }));

//   //画像を削除するイベント
//   $(document).on('click', '#photo_delete', function() {
//     // console.log("OK");
//     //プレビューの要素を取得
//     var target_photo = $(this).parent().parent();
//     //プレビューを削除
//     console.log(target_photo)
//     target_photo.remove();
//     //inputタグに入ったファイルを削除
//     // file_field.val(""); //←この記述を書くとconsoleにエラーが生じるのでコメントアウトしておきます
//   })
// });



// $(function(){
//     //inputボタンが増殖する記述
//   var input_area = $('.input-area');

//   $(document).on('change','#post_img,#post_img_last',function(event){
//     var new_input = $('<input type="file" multiple="multiple" class="sell__upload__drop-file" name="item[images][]" id="post_img">');
//     input_area.prepend(new_input);
//   })

//   // 一番新しいinputを押せるようにして古いinputは消す記述
//   $(document).on('change', '#post_img,#post_img_last',function(event) {
//     // 一番上のインプットだけ押せるように表示。
//     $('.input-area').children(":first").css({'display':'block'});
//     // 選択したインプットは消す。
//     $(this).css({'display':'none'});
//   });
  
// })



// const html = `<div class="item-image">
//                     <img  src="${url}" width="114px" height="114px">
//                     <div class="btn_wrapper">
//                       <label for="item_images_attributes_0_image">編集</label>
//                       <span class="js-remove">削除</span>
//                     </div>
//                   </div>`
//     return html;
