# LINEBOT処理用のモジュール
# 参考:
# http://qiita.com/Arahabica/items/98e3d0d5b65269386dc4

require "faraday"
require "faraday_middleware"
require "json"
require "pp"

class LineClient

  # LINEBOT用の定数値
  # ※詳細は後で調べておく...
  # 参考：LINEの公式APIドキュメント
  # https://developers.line.me/bot-api/getting-started-with-bot-api-trial#signature_validation
  END_POINT  = "https://trialbot-api.line.me"
  TO_CHANNEL = 1383378250
  EVENT_TYPE = "138311608800106203"

  # LINEBOTに表示するコンテンツタイプ
  module ContentType
    TEXT     = 1
    IMAGE    = 2
    VIDEO    = 3
    AUDIO    = 4
    LOCATION = 7
    STICKER  = 8
    CONTACT  = 10
  end

  # ユーザータイプ定数
  module ToType
    USER = 1
  end

  # インスタンス変数の初期化
  def initialize(channel_id, channel_secret, channel_mid, proxy = nil)
    @channel_id = channel_id
    @channel_secret = channel_secret
    @channel_mid = channel_mid
    @proxy = proxy
  end

  # LINEBOTへのアクセスを行うメソッド
  def send(line_ids, message)
    post('/v1/events', {
        to: line_ids,
        content: {
            contentType: ContentType::TEXT,
            toType: ToType::USER,
            text: message
        },
        toChannel: TO_CHANNEL,
        eventType: EVENT_TYPE
    })
  end

  private

  # LINEBOTへのPOSTリクエスト用のデータを作成するメソッド
  def post(path, data)
    client = Faraday.new(:url => END_POINT) do |conn|
      conn.request :json
      conn.response :json, :content_type => /\bjson$/
      conn.adapter Faraday.default_adapter
      conn.proxy @proxy
    end

    res = client.post do |request|
      request.url path
      request.headers = {
          'Content-type' => 'application/json; charset=UTF-8',
          'X-Line-ChannelID' => @channel_id,
          'X-Line-ChannelSecret' => @channel_secret,
          'X-Line-Trusted-User-With-ACL' => @channel_mid
      }
      request.body = data
    end
    res
  end
end
