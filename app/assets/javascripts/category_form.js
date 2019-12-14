$(function() {
  //カテゴリーセレクトボックスのオプションを作成
  function appendOption(category) {
  //function 関数名 (引数){関数を定義する文}  
    var html = `<option value="${category.name}" data-category="${category.id}">${category.name}</option>`;
    return html;
  }
  //子カテゴリーのhtml作成
  function appendChidrenBox(insertHTML) {
    var childSelectHtml = '';
    childSelectHtml = `<div class="choose__wrap" id="children-wrapper">
                        <select class="choose__cell" id="children-category" name="category_id">
                        <%= fa_icon 'angle-down', class: 'icon-down' %>
                          <option>---</option>
                          ${insertHTML}
                        </select>
                      </div>`;
    $('.sell__container__form__box__category-wrapper').append(childSelectHtml);
    //appendメソッドとは？→$('セレクタ').append('追加するもの');
  }
  //孫カテゴリーのhtml作成
  function appendGrandchildrenBox(insertHTML) {

    var grandchildSelectHtml = '';
    grandchildSelectHtml = `<div class="choose__wrap" id="grandchildren-wrapper">
                              <select class="choose__cell" id="grandchildren-category" name="category_id">
                              <%= fa_icon 'angle-down', class: 'icon-down' %>
                                <option>---</option>
                                ${insertHTML}
                              </select>
                            </div>`;
    $('.sell__container__form__box__category-wrapper').append(grandchildSelectHtml);
    //appendメソッドとは？→$('セレクタ').append('追加するもの');
  }
  //親カテゴリー選択後のイベント
  $('#parent-category').on('change', function() {
    //親カテゴリーのidを取得してそのidをAjax通信でコントローラーへ送る
    var parentCategory = document.getElementById("parent-category").value;
    //("parent-category")は親カテゴリーのid属性
    if (parentCategory != "---") { //親カテゴリーが初期値でないことを確認
      $.ajax({
        url: '/items/search',
        type: 'GET',
        dataType: 'json',
        data: {parent_id: parentCategory} //親カテゴリーの値を変数parent_idに代入
      })
      .done(function(children) {
        $('#children-wrapper').remove(); //親が変更された時、子以下を削除するする
        $('#grandchildren-wrapper').remove();
        var insertHTML = '';
        children.forEach(function(child) {
          insertHTML += appendOption(child);
        });
        appendChidrenBox(insertHTML);
      })
      .fail(function() {
        alert('カテゴリー取得に失敗しました');
      })
    } else {
      $('#children-wrapper').remove(); //親カテゴリーが初期値になった時、子以下を削除するする
      $('#grandchildren-wrapper').remove();
    }
  })
  //子カテゴリー選択後のイベント
  $('.sell__container__form__box__category-wrapper').on('change', '#children-category',function() {
    var childId = $('#children-category option:selected').data('category'); //選択された子カテゴリーのidを取得
    if (childId != "---") { //子カテゴリーが初期値でないことを確認
      $.ajax({
        url: '/items/search',
        type: 'GET',
        dataType: 'json',
        data: {child_id: childId} //子カテゴリーの値を変数child_idに代入
      })
      .done(function(grandchildren) {
        if (grandchildren.length != 0) {
          $('#grandchildren-wrapper').remove(); //子が変更された時、孫以下を削除するする
          var insertHTML = '';
          grandchildren.forEach(function(grandchild) {
            insertHTML += appendOption(grandchild);
          });
          appendGrandchildrenBox(insertHTML);
        }
      })
      .fail(function() {
        alert('カテゴリーの取得に失敗しました');
      })
    } else {
      $('#grandchildren-wrapper').remove(); //子カテゴリーが初期値になった時、孫以下を削除する
    }
  })
  //孫カテゴリー選択後のイベント
  $('.sell__container__form__box__category-wrapper').on('change', '#grandchildren-category',function() {
    //サイズのセレクトボックス
    var slectBoxForSize = '';
    slectBoxForSize = `<div class='sell__container__form__box__group2' id='select-size'>
                        <label class='item__label'>
                          サイズ
                          <span class='required'>
                            必須
                          </span>
                        </label>
                        <div class="choose__wrap" id="size-wrapper">
                        <select class="choose__cell" id="size-select">
                        <%= fa_icon 'angle-down', class: 'icon-down' %>
                        </select>
                      </div>
                      <div class='sell__container__form__box__group2' id='select-brand'>
                        <label class='item__label'>
                          ブランド
                          <span class='optional'>
                            任意
                          </span>
                        </label>
                        <div class="choose__wrap" id="brand-wrapper">
                        <input class='sell__container__form__contents__area1__input'>
                        </select>
                      </div>`;
      $('.sell__container__form__box__category-wrapper').append(slectBoxForSize);
    // //レディースの靴のサイズのセレクトボックス
    // var selectBoxForLadiesShoes = '';
    // selectBoxForLadiesShoes = `<div class='sell__container__form__box__group2' id='select-size'>
    //                             <label class='item__label'>
    //                               サイズ
    //                               <span class='required'>
    //                                 必須
    //                               </span>
    //                             </label>
    //                             <div class="choose__wrap" id="ladiessshoessize-wrapper">
    //                             <select class="choose__cell" id="ladiesshoessize-select" name="category_id">
    //                             <%= fa_icon 'angle-down', class: 'icon-down' %>
    //                               <option>---</option>
    //                               <option>20cm以下</option>
    //                               <option>20.5cm</option>
    //                               <option>21cm</option>
    //                               <option>21.5cm</option>
    //                               <option>22cm</option>
    //                               <option>22.5cm</option>
    //                               <option>23cm</option>
    //                               <option>23.5cm</option>
    //                               <option>24cm</option>
    //                               <option>24.5cm</option>
    //                               <option>25cm</option>
    //                               <option>25.5cm</option>
    //                               <option>26cm</option>
    //                               <option>26.5cm</option>
    //                               <option>27cn</option>
    //                               <option>27.5cm以上</option>
    //                             </select>
    //                           </div>`;
    // $('.sell__container__form__box__category-wrapper').append(selectBoxForLadiesShoes);
    // //メンズの靴のサイズのセレクトボックス
    // var selectBoxForMensShoes = '';
    // selectBoxForMensShoes = `<div class='sell__container__form__box__group2' id='select-size'>
    //                           <label class='item__label'>
    //                             サイズ
    //                             <span class='required'>
    //                               必須
    //                             </span>
    //                           </label>
    //                           <div class="choose__wrap" id="menssshoessize-wrapper">
    //                           <select class="choose__cell" id="mensshoessize-select" name="category_id">
    //                           <%= fa_icon 'angle-down', class: 'icon-down' %>
    //                             <option>---</option>
    //                             <option>23.5cm以下</option>
    //                             <option>24cm</option>
    //                             <option>24.5cm</option>
    //                             <option>25cm</option>
    //                             <option>25.5cm</option>
    //                             <option>26cm</option>
    //                             <option>26.5cm</option>
    //                             <option>27cm</option>
    //                             <option>27.5cm</option>
    //                             <option>28cm</option>
    //                             <option>28.5cm</option>
    //                             <option>29cm</option>
    //                             <option>29.5cm</option>
    //                             <option>30cm</option>
    //                             <option>30.5cm</option>
    //                             <option>31cm以上</option>
    //                           </select>
    //                         </div>`;
    // $('.sell__container__form__box__category-wrapper').append(selectBoxForMensShoes);
    // //ベビー・キッズの靴のサイズのセレクトボックス
    // var selectBoxForBabyKidsShoes = '';
    // selectBoxForBabyKidsShoes = `<div class='sell__container__form__box__group2' id='select-size'>
    //                               <label class='item__label'>
    //                                 サイズ
    //                                 <span class='required'>
    //                                   必須
    //                                 </span>
    //                               </label>
    //                               <div class="choose__wrap" id="babykidsshoessize-wrapper">
    //                               <select class="choose__cell" id="babykidsshoessize-select" name="category_id">
    //                               <%= fa_icon 'angle-down', class: 'icon-down' %>
    //                                 <option>---</option>
    //                                 <option>10.5cm以下</option>
    //                                 <option>11cm・11.5cm</option>
    //                                 <option>12cm・12.5cm</option>
    //                                 <option>13cm・13.5cm</option>
    //                                 <option>14cm・14.5cm</option>
    //                                 <option>15cm・15.5cm</option>
    //                                 <option>16cm・16.5cm</option>
    //                                 <option>17cm以上</option>
    //                               </select>
    //                             </div>`;
    // $('.sell__container__form__box__category-wrapper').append(selectBoxForBabyKidsShoes);
    // //服のサイズ(メンズ・レディース)のセレクトボックス
    // var selectBoxForClothes = '';
    // selectBoxForClothes = `<div class='sell__container__form__box__group2' id='select-size'>
    //                         <label class='item__label'>
    //                           サイズ
    //                           <span class='required'>
    //                             必須
    //                           </span>
    //                         </label>
    //                         <div class="choose__wrap" id="clothessize-wrapper">
    //                         <select class="choose__cell" id="clothessize-select" name="category_id">
    //                         <%= fa_icon 'angle-down', class: 'icon-down' %>
    //                           <option>---</option>
    //                           <option>XXS以下</option>
    //                           <option>XS(SS)</option>
    //                           <option>S</option>
    //                           <option>M</option>
    //                           <option>L</option>
    //                           <option>XL(LL)</option>
    //                           <option>2XL(3L)</option>
    //                           <option>3XL(4L)</option>
    //                           <option>4XL(5L)以上</option>
    //                           <option>FREE SIZE</option>
    //                         </select>
    //                       </div>`;
    // $('.sell__container__form__box__category-wrapper').append(selectBoxForClothes);
    // //ベビー服のサイズ(~95cm)のセレクトボックス
    // var selectBoxForBabyClothes = '';
    // selectBoxForBabyClothes = `<div class='sell__container__form__box__group2' id='select-size'>
    //                             <label class='item__label'>
    //                               サイズ
    //                               <span class='required'>
    //                                 必須
    //                               </span>
    //                             </label>
    //                             <div class="choose__wrap" id="babyclothessize-wrapper">
    //                             <select class="choose__cell" id="babyclothessize-select" name="category_id">
    //                             <%= fa_icon 'angle-down', class: 'icon-down' %>
    //                               <option>---</option>
    //                               <option>60cm</option>
    //                               <option>70cm</option>
    //                               <option>80cm</option>
    //                               <option>90cm</option>
    //                               <option>95cm</option>
    //                             </select>
    //                           </div>`;
    // $('.sell__container__form__box__category-wrapper').append(selectBoxForBabyClothes);
    // //キッズ服のサイズ(100cm~)のセレクトボックス
    // var selectBoxForKidsClothes = '';
    // selectBoxForKidsClothes = `<div class='sell__container__form__box__group2' id='select-size'>
    //                             <label class='item__label'>
    //                               サイズ
    //                               <span class='required'>
    //                                 必須
    //                               </span>
    //                             </label>
    //                             <div class="choose__wrap" id="kidsclothessize-wrapper">
    //                             <select class="choose__cell" id="kidsclothessize-select" name="category_id">
    //                             <%= fa_icon 'angle-down', class: 'icon-down' %>
    //                               <option>---</option>
    //                               <option>100cm</option>
    //                               <option>110cm</option>
    //                               <option>120cm</option>
    //                               <option>130cm</option>
    //                               <option>140cm</option>
    //                               <option>150cm</option>
    //                               <option>160cm</option>
    //                             </select>
    //                           </div>`;
    // $('.sell__container__form__box__category-wrapper').append(selectBoxForKidsClothes);    
    // var parentValue = $('#parent-category').val();
    // var childrenValue = $('#children-category').val();
    // var radiesShoes = Category.where(id=56);
    // alert(radiesShoes);
    // var mensShoes = Category.where(id=178);
    // if (radiesShoes) {
    //   $('.sell__container__form__box__category-wrapper').append(selectBoxForLadiesShoes);
    // }
    // if (mensShoes) {
    //   $('.sell__container__form__box__category-wrapper').append(selectBoxForMensShoes);
    // }
  })

  //配送料の負担を選択後のイベント
  $('.sell__container__form__box__delivery-wrapper').on('change', function() {
    //配送料の負担の選択値を変数shippingChargeに代入
    var shippingCharge = $("#delivery").val();
    //shippingCharge == "1"すなわち送料込み(出品者負担)の場合の条件分岐
    if (shippingCharge == "1") {
      $('#delivery-wrapper').remove();
      var postageIncluded = "";
      postageIncluded = `<div class='sell__container__form__box__group2' id='delivery-way'>
                          <label class='item__label'>
                            配送の方法
                            <span class='required'>
                              必須
                            </span>
                          </label>
                          <div class='choose__wrap'>
                            <select class='choose__cell'>
                              <option>---</option>
                              <option>未定</option>
                              <option>らくらくメルカリ便</option>
                              <option>ゆうメール</option>
                              <option>レターパック</option>
                              <option>普通郵便(定形、定形外)</option>
                              <option>クロネコヤマト</option>
                              <option>ゆうパック</option>
                              <option>クリックポスト</option>
                              <option>ゆうパケット</option>
                            </select>
                          </div>
                        </div>`
      $('.sell__container__form__box__delivery-wrapper').append(postageIncluded);
    }
    //shippingCharge == "2"すなわち着払い(購入者負担)の場合の条件分岐
    if (shippingCharge == "2") {
      $('#delivery-wrapper').remove();
      var cashOnDelivery ='';
      cashOnDelivery = `<div class='sell__container__form__box__group2' id='delivery-way'>
                         <label class='item__label'>
                           配送の方法
                           <span class='required'>
                             必須
                           </span>
                         </label>
                         <div class='choose__wrap'>
                           <select class='choose__cell'>
                             <option>---</option>
                             <option>未定</option>
                             <option>クロネコヤマト</option>
                             <option>ゆうパック</option>
                             <option>ゆうメール</option>
                           </select>
                          </div>
                        </div>`
      $('.sell__container__form__box__delivery-wrapper').append(cashOnDelivery);
    }
  })
});
