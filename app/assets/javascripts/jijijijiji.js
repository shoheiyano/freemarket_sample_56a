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