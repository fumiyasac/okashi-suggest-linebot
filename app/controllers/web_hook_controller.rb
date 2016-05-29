require 'rexml/document'
require 'open-uri'
require 'line_client'

# LINEBOT及びネイティブアプリ用のコントローラー
# 参考: http://qiita.com/Arahabica/items/98e3d0d5b65269386dc4
class WebHookController < ApplicationController

  # CSRF対策無効化
  protect_from_forgery with: :null_session

  # 会話からお菓子をサジェストするモジュールの読み込み
  include AnalizeApi
  include CategoryList
  include OkashiOutput

  # LINE BOTのエンドポイントになる部分
  def index

    # LINEアクセスからのものでなければエラーとする
    unless is_validate_signature
      render :nothing => true, status: 470
    end

    # LINEBOTから送られてきた情報を取得する
    result = params[:result][0]
    logger.info({from_line: result})
    from_mid = result['content']['from']
    text_message = result['content']['text']

    # 引数：text_messageの内容を解析して返却する
    target_text = analize_text(text_message)
    category_check = category_result_from_api(target_text)

    type = decide_category_from_api(category_check)
    if type.present?
      category_flag = true
      xml_uri = URI.encode("http://www.sysbird.jp/webapi/?apikey=guest&order=r&max=1&type=#{type}")
    else
      category_flag = false
      query_string = target_text.join(",")
      xml_uri = URI.encode("http://www.sysbird.jp/webapi/?apikey=guest&order=r&max=1&keyword=#{query_string}")
    end

    doc = REXML::Document.new(open(xml_uri))
    result_message = get_target_okashi(doc, category_flag)

    # herokuに設定する定数値
    # $ heroku config:add LINE_CHANNEL_ID = "XXXXXXXXXXXX"
    # $ heroku config:add LINE_CHANNEL_SECRET = "XXXXXXXXXXXX"
    # $ heroku config:add LINE_CHANNEL_MID = "XXXXXXXXXXXX"

    # LINEBOTクライアント用のインスタンスを作成する
    client = LineClient.new(
      ENV['LINE_CHANNEL_ID'],
      ENV['LINE_CHANNEL_SECRET'],
      ENV['LINE_CHANNEL_MID'],
      ENV['LINE_OUTBOUND_PROXY']
    )
    res = client.send([from_mid], result_message)

    # 成功及び失敗時のログ出力
    if res.status == 200
      logger.info({success: res})
    else
      logger.info({fail: res})
    end
    render :nothing => true, status: :ok
  end

  private

    # LINEからのアクセスか確認.
    # 認証に成功すればtrueを返す。
    # ref) https://developers.line.me/bot-api/getting-started-with-bot-api-trial#signature_validation
    def is_validate_signature
      signature = request.headers["X-LINE-ChannelSignature"]
      http_request_body = request.raw_post
      hash = OpenSSL::HMAC::digest(OpenSSL::Digest::SHA256.new, ENV['LINE_CHANNEL_SECRET'], http_request_body)
      signature_answer = Base64.strict_encode64(hash)
      signature == signature_answer
    end
end
