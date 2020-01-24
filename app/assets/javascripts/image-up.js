$(function(){

  //取得したカスタムデータ属性がhtmlに引数として渡され、下の場所に表示される
  var input_place = $(".sell__container__form__upload");

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

      
        
        //データ属性を取得してinputに送る
      function appendImages(array) {
        var html =`<div class="input-area2">
                  <input multiple="multiple" type="text" class="sell__upload__drop-file-delete" id="post_img_last" name="item[image_id][]" value="${ array }">
                  <label class="text" for="post_img_last">
                  </label>
                  </div>`

      input_place.append(html);
      }

      

      var image_id = $(this).parent().parent().data("image-id");
          // console.log(image_id);
      var hairetu = [];

       hairetu.push(image_id);
      console.log(hairetu)
      hairetu.filter(Boolean);

      var array = hairetu.filter(Boolean);

      $(this).parent().parent().remove();
      appendImages(array);
      //sell__upload__drop-file-deleteをdocument.getElementsByClassNameで拾ってHTML.collectionに入れてる。変数inputを作る。
      
      var  inputs = document.getElementsByClassName('sell__upload__drop-file-delete')
      console.log(inputs);
      //Array.prototype.slice.callがHTMLコレクションを配列にするための記述。配列になったHTMLコレクションをindに代入。
      var ind = Array.prototype.slice.call(inputs)
      //indの中身を出していく。iが番号
      $.each(ind, function(i, input){
        console.log($(input).val())
        //inputの値が空なら、inputが削除される条件分岐
        if($(input).val() === ''){
          $(input).parent().remove()
        }
      })

  //削除を押されたプレビュー要素を取得
  //////////////////////////////////////////////////////////一旦隠す。いらない？と思い隠した記述
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
  // image-box__containerクラスをもつdivタグのクラスを削除のたびに変更
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