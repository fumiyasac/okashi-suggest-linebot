require 'rails_helper'

# CategoryListモジュールに関するテストケース
describe CategoryList do

  # CategoryListモジュールを利用するためのダミーのクラスファイルを作成する
  let(:test_class) { Struct.new(:category_list) { include CategoryList } }
  let(:category_list) { test_class.new }

  # カテゴリーのジャッジを行うメソッドに関するテストケース
  describe "category_result_from_apiメソッドに関するテスト" do
    context "カテゴリーに該当する文言があるか否かの判定をするテスト" do
      it "['せんべい']と入力するとハッシュのsenbei_result:がtrueになる" do
        expect(category_list.category_result_from_api(['せんべい'])).to eq(
          {
            snack_result: false,
            chocolate_result: false,
            cookie_result: false,
            candy_result: false,
            senbei_result: true
          }
        )
      end
      it "配列['せんべい','チョコレート','ソフトクリーム']と入力するとハッシュのsenbei_result:とchocolate_result:がtrueになる" do
        expect(category_list.category_result_from_api(['せんべい','チョコレート','ソフトクリーム'])).to eq(
          {
            snack_result: false,
            chocolate_result: true,
            cookie_result: false,
            candy_result: false,
            senbei_result: true
          }
        )
      end
      it "配列['ごま団子','ソフトクリーム']と入力するとfalseになる" do
        expect(category_list.category_result_from_api(['ごま団子','ソフトクリーム'])).to eq(
          {
            snack_result: false,
            chocolate_result: false,
            cookie_result: false,
            candy_result: false,
            senbei_result: false
          }
        )
      end
    end
    context "各カテゴリー判定結果からお菓子の虜WebAPIに当てはめるカテゴリーに関するテスト" do
      it "cookie_result:がtrueの際は3(CATEGORY_OKASHI_APIでの設定値)になる" do
        expect(category_list.decide_category_from_api(
          {
            snack_result: false,
            chocolate_result: false,
            cookie_result: true,
            candy_result: false,
            senbei_result: false
          }
        )).to eq(3)
      end
      it "senbei_result:がtrueかつchocolate_result:がtrueの際は2または5(CATEGORY_OKASHI_APIでの設定値)になる" do
        expect(category_list.decide_category_from_api(
          {
            snack_result: false,
            chocolate_result: true,
            cookie_result: false,
            candy_result: false,
            senbei_result: true
          }
        )).to eq(2).or eq(5)
      end
      it "カテゴリー判定のハッシュ内が全てfalseの場合は返り値はfalseになる" do
        expect(category_list.decide_category_from_api(
          {
            snack_result: false,
            chocolate_result: false,
            cookie_result: false,
            candy_result: false,
            senbei_result: false
          }
        )).to eq(false)
      end
    end
  end

end
