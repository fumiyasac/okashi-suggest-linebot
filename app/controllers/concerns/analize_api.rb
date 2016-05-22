# 形態素解析を利用してお菓子をレコメンドするモジュール

require 'yahoo_parse_api'

module AnalizeApi

  # 形態素解析を利用して食べたいお菓子をレコメンドするメソッド
  def analize_text(target_text)

    # 使用しているAPIはこちら
    # 参考1：Yahoo形態素解析API
    # http://developer.yahoo.co.jp/webapi/jlp/ma/v1/parse.html
    # 参考2：お菓子の虜WebAPI
    # http://www.sysbird.jp/toriko/webapi/

    YahooParseApi::Config.app_id = ENV['YAHOO_API_KEY']
    parse_api = YahooParseApi::Parse.new

    # 引数で渡された文言を形態素解析する
    response_from_api = parse_api.parse(target_text, {
      results: 'ma,uniq',
      ma_filter: '9|10',
      uniq_filter: '9|10'
    })
    result_from_api = response_from_api["ResultSet"]["ma_result"]["word_list"]["word"]

    # 名詞の配列リストを作成する
    results = []
    result_from_api.each do |result|
      results << result["surface"] if result["pos"] == "名詞"
    end
    results
  end

end
