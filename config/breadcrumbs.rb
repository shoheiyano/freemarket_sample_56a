crumb :root do
  link "メルカリ", root_path
end

crumb :mypage do
  link "マイページ", mypage_path
end

crumb :logout do
  link "ログアウト", logout_path
  parent :mypage
end

crumb :card do
  link "支払い方法", add_card_card_index_path
end

crumb :card do
  link "支払い方法", new_card_path
end

crumb :card do
  link "支払い方法", card_index_path
end

crumb :ladies do
  link "レディース", ladies_items_path
end

crumb :mens do
  link "メンズ", mens_items_path
end

crumb :appliances do
  link "家電・スマホ・カメラ", appliances_items_path
end

crumb :hobby do
  link "おもちゃ・ホビー・グッズ", hobby_items_path
end

crumb :chanel do
  link "シャネル", chanel_items_path
end

crumb :louis_vuitton do
  link "ルイヴィトン", louis_vuitton_items_path
end

crumb :supreme do
  link "シュプリーム", supreme_items_path
end

crumb :nike do
  link "ナイキ", nike_items_path
end

# crumb :project_issues do |project|
#   link "Issues", project_issues_path(project)
#   parent :project, project
# end

# crumb :issue do |issue|
#   link issue.title, issue_path(issue)
#   parent :project_issues, issue.project
# end

# If you want to split your breadcrumbs configuration over multiple files, you
# can create a folder named `config/breadcrumbs` and put your configuration
# files there. All *.rb files (e.g. `frontend.rb` or `products.rb`) in that
# folder are loaded and reloaded automatically when you change them, just like
# this file (`config/breadcrumbs.rb`).