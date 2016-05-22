# カテゴリの一覧リスト用のモジュール

module CategoryList

  # カテゴリーが「スナック菓子」になるワード
  CATEGORY_SNACK_WORD = [
    "スナック",
    "すなっく",
    "snack",
    "スナック菓子",
    "すなっく菓子",
    "スナックがし",
    "スナックガシ"
  ]

  # カテゴリーが「チョコレート」になるワード
  CATEGORY_CHOCO_WORD = [
    "チョコレート",
    "ちょこれーと",
    "チョコレイト",
    "ちょこれいと",
    "chocolate",
    "choco",
    "チョコ",
    "ちょこ"
  ]

  CATEGORY_OKASHI_API = {
    snack_result: 1,
    chocolate_result: 2,
    cookie_result: 3,
    candy_result: 4,
    senbei_result: 5
  }

  def decide_category_from_api(results = {})
    result = []
    result << CategoryList::CATEGORY_OKASHI_API[:snack_result]     if results[:snack_result].present?
    result << CategoryList::CATEGORY_OKASHI_API[:chocolate_result] if results[:chocolate_result].present?
    result << CategoryList::CATEGORY_OKASHI_API[:cookie_result]    if results[:cookie_result].present?
    result << CategoryList::CATEGORY_OKASHI_API[:candy_result]     if results[:candy_result].present?
    result << CategoryList::CATEGORY_OKASHI_API[:senbei_result]    if results[:senbei_result].present?
    result.sample
  end

  # お菓子の虜WebAPIを利用して語句から検索する
  def category_result_from_api(words = [])
    unless words.empty?
      {
        snack_result: match_category_result?(words, CategoryList::CATEGORY_SNACK_WORD),
        chocolate_result: match_category_result?(words, CategoryList::CATEGORY_CHOCO_WORD)
      }
    else
      false
    end
  end

  # カテゴリーの語句に一致するものがあればtrueとする
  def match_category_result?(words, category)
    true_count = 0
    unless words.present? || category.present?
      false
    end
    words.each do |word|
      true_count += 1 if category.include?(word)
    end
    (true_count > 0)
  end

end
