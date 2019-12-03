$(function() {
  //カテゴリーセレクトボックスのオプションを作成
  function appendOption(category) {
  //function 関数名 (引数){関数を定義する文}  
    var html = `<option value="${category.name}" data-category="${category.id}">${category.name}</option>`;
    return html;
  }
  //子カテゴリーのhtml作成
  function appendChildrenBox(insertHTML) {
    var childSelectHtml = '';
    childSelectHtml = `<div class="choose__wrap">
                        <%= fa_icon 'angle-down', class: 'icon-down' %>
                        <select class="choose__cell" id="child_category" name="category_id">
                          <option>---</option>
                          ${insertHTML}
                        </select>
                      </div>`;
    $('.sell__container__form__box__group1').append(childSelectHtml);
    //appendメソッドとは？→$('セレクタ').append('追加するもの');
  }
  //孫カテゴリーのhtml作成
  function appendGrandchildrenBox(insertHTML) {
    var grandchildSelectHtml = '';
    grandchildSelectHtml = `<div class="choose__wrap">
                          <%= fa_icon 'angle-down', class: 'icon-down' %>
                          <select class="choose__cell" id="grandchild_category" name="category_id">
                            <option>---</option>
                            ${insertHTML}
                          </select>
                        </div>`;
    $('.sell__container__form__box__group1').append(grandchildSelectHtml);
    //appendメソッドとは？→$('セレクタ').append('追加するもの');
  }
  //親カテゴリー選択後のイベント
  $('#parent-category').on('change', function() {
    //親カテゴリーのidを取得してそのidをAjax通信でコントローラーへ送る
    var parentCategory = document.getElementById("parent-category").value;
    //("parent-category")は親カテゴリーのid属性
    console.log(parentCategory); // 値が取れてるか確認しましたが取れておらず・・・・・・
    if (parentCategory != "---") { //親カテゴリーが初期値でないことを確認
      $.ajax({
        url: '/items/search',
        type: 'GET',
        dataType: 'json',
        data: {parent_id: parentCategory}//親カテゴリーの値を変数parent_idに代入
      })
      .done(function(children) {
        var insertHTML = '';
        children.forEach(function(child) {
          insertHTML += appendOption(child);
        });
        appendChidrenBox(insertHTML);
      })
      .fail(function() {
        alert('カテゴリー取得に失敗しました');
      })
    }
  });
  //子カテゴリー選択後のイベント
  $('.sell__container__form__box__group1').on('change', function() {
    var childId = $('#child_category option:selected').data('category'); //選択された子カテゴリーのidを取得
    if (childId != "---") { //子カテゴリーが初期値でないことを確認
      $.ajax({
        url: ,
        type: 'GET',
        dataType: 'json',
        data: {child_id: childId}//子カテゴリーの値を変数child_idに代入
      })
      .done(function(grandchildren) {
        var insertHTML = '';
        grandchildren.forEach(function(grandchild) {
          insertHTML += appendOption(grandchild);
        });
        appendGrandchildrenBox(insertHTML);
      })
      .fail(function() {
        alert('カテゴリーの取得に失敗しました')
      })
    }
  })
});
