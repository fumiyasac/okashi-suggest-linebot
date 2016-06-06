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

  # カテゴリーが「クッキー」になるワード
  CATEGORY_COOKIE_WORD = [
    "クッキー",
    "クッキィ",
    "くっきー",
    "くっきぃ",
    "cookie"
  ]

  # カテゴリーが「キャンディー」になるワード
  CATEGORY_CANDY_WORD = [
    "キャンディー",
    "キャンディ",
    "キャンデイ",
    "きゃんでぃー",
    "きゃんでぃ",
    "きゃんでい",
    "cookie"
  ]

  # カテゴリーが「せんべい」になるワード
  CATEGORY_SENBEI_WORD = [
    "せんべい",
    "せんべえ",
    "せんべぇ",
    "煎餅",
    "お煎餅",
    "センベイ",
    "センベェ",
    "センベエ",
    "おせんべい",
    "おせんべえ",
    "おせんべぇ",
    "senbei"
  ]

  CATEGORY_OKASHI_API = {
    snack_result: 1,
    chocolate_result: 2,
    cookie_result: 3,
    candy_result: 4,
    senbei_result: 5
  }

  # お菓子の虜WebAPIのカテゴリーの数字を判定して複数の場合ランダムに1つだけを抜き出す
  def decide_category_from_api(results = {})
    result = []
    result << CategoryList::CATEGORY_OKASHI_API[:snack_result]     if results[:snack_result].present?
    result << CategoryList::CATEGORY_OKASHI_API[:chocolate_result] if results[:chocolate_result].present?
    result << CategoryList::CATEGORY_OKASHI_API[:cookie_result]    if results[:cookie_result].present?
    result << CategoryList::CATEGORY_OKASHI_API[:candy_result]     if results[:candy_result].present?
    result << CategoryList::CATEGORY_OKASHI_API[:senbei_result]    if results[:senbei_result].present?
    unless result.empty?
      result.sample
    else
      false
    end
  end

  # お菓子の虜WebAPIを利用して語句から検索する
  def category_result_from_api(words = [])
    unless words.empty?
      {
        snack_result: match_category_result?(words, CategoryList::CATEGORY_SNACK_WORD),
        chocolate_result: match_category_result?(words, CategoryList::CATEGORY_CHOCO_WORD),
        cookie_result: match_category_result?(words, CategoryList::CATEGORY_COOKIE_WORD),
        candy_result: match_category_result?(words, CategoryList::CATEGORY_CANDY_WORD),
        senbei_result: match_category_result?(words, CategoryList::CATEGORY_SENBEI_WORD)
      }
    else
      false
    end
  end

  private

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
