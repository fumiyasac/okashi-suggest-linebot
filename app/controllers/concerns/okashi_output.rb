# お菓子の虜WebAPiへアクセスしてデータを取得するモジュール

require 'rexml/document'

module OkashiOutput

  def get_target_okashi(doc, category_flag)
    okashi_name = doc.elements['okashinotoriko/item/name'].text
    okashi_price = doc.elements['okashinotoriko/item/price'].text
    okashi_image = doc.elements['okashinotoriko/item/image'].text
    okashi_url = doc.elements['okashinotoriko/item/url'].text
    if category_flag
      message = "もしかすると要望に近いものはこれかも？気に入ってくれれば嬉しいな＾＾¥n"
    else
      message = "ちょっと自信ないんだけどもしかしたらこれなんかどうかな？・・?¥n"
    end
    massage = message + "¥n#{okashi_name}¥n" + "#{okashi_price}¥n" + "#{okashi_image}¥n" + "#{okashi_url}"
  end

end
