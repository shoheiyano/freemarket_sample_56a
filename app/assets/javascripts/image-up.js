$(function () {


  function buildhtml(url){
    const html = `<div class="item-image">
                    <img  src="${url}" width="114px" height="114px">
                    <div class="btn_wrapper">
                      <label for="item_images_attributes_0_image">編集</label>
                      <span class="js-remove">削除</span>
                    </div>
                  </div>`
    return html;
  }

  $('.hidden').change(function (e) {
    e.preventDefault()
      // 画像の情報を取得
      var file = this.files[0];
      //var file = e.target.files[0];
      //var url = window.URL.createObjectURL(file);

      var img_tag_id = $(this).data('imageTagId');
      console.log(file)
      

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
         $(".previews").append(html)
      }

      // 画像の読み込み
      reader.readAsDataURL(file);
  });
});