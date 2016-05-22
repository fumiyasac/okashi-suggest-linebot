# LINEBOT及びネイティブアプリ用のコントローラー
# 参考:
# http://qiita.com/Arahabica/items/98e3d0d5b65269386dc4

class WebHookController < ApplicationController

  # CSRF対策無効化
  protect_from_forgery with: :null_session

  include AnalizeApi

  def test
    analize_textdata('おせんべい食いてぇなー。')
  end

  # LINE BOTのエンドポイントになる部分
  def index

    # LINEアクセスからのものでなければエラーとする
    unless is_validate_signature
      render :nothing => true, status: 470
    end

    # LINEBOTから送られてきた情報を取得する
    result = params[:result][0]
    logger.info({from_line: result})
    text_message = result['content']['text']
    from_mid = result['content']['from']

    # LINEBOTクライアント用のインスタンスを作成する
    client = LineClient.new(CHANNEL_ID, CHANNEL_SECRET, CHANNEL_MID, OUTBOUND_PROXY)
    res = client.send([from_mid], text_message)

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
      hash = OpenSSL::HMAC::digest(OpenSSL::Digest::SHA256.new, CHANNEL_SECRET, http_request_body)
      signature_answer = Base64.strict_encode64(hash)
      signature == signature_answer
    end
end
