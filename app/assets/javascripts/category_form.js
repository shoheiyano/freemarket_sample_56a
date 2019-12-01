// 親カテゴリー選択後のイベント
$('#parent-category').on('change', function() {
  // 親カテゴリーのidを取得してそのidをAjax通信でコントローラーへ送る
  var parentCategory = document.getElementById("parent-category").value;
  // ("parent-category")は親カテゴリーのid属性
  if (parentCategory != "---") {// 親カテゴリーが初期値でないことを確認
    $.ajax ({
      url: '/items/search',
      type: 'GET',
      dataType: 'json',
      data: {parent_id: parentCategory}// 親カテゴリーの値を変数parent_idに代入
    })
  }
})
