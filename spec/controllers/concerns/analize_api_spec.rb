require 'rails_helper'

# AnalizeApiモジュールに関するテストケース
describe AnalizeApi do

  # AnalizeApiモジュールを利用するためのダミーのクラスファイルを作成する
  let(:test_class) { Struct.new(:analize_api) { include AnalizeApi } }
  let(:analize_api) { test_class.new }

  # Yahoo形態素解析を行うメソッドに関するテストケース
  describe "analize_textメソッドに関するテスト" do
    context "Yahoo形態素解析APIでの名詞データ返却に関するテスト" do
      it "「せんべい」と入力すると「せんべい」だけが配列に格納されて出力される" do
        expect(analize_api.analize_text("せんべい")).to eq ["せんべい"]
      end
      it "「せんべいが食べたい」と入力すると「せんべい」だけが配列に格納されて出力される" do
        expect(analize_api.analize_text("せんべいが食べたい")).to eq ["せんべい"]
      end
      it "「チョコレートとせんべいが食べたい」と入力すると「チョコレート」「せんべい」が配列に格納されて出力される" do
        expect(analize_api.analize_text("チョコレートとせんべいが食べたい")).to eq ["チョコレート", "せんべい"]
      end
    end
  end
end
