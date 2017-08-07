require 'rails_helper'

describe Admin::StaffMembersController do
  # atributes_for FactoryGirlのメソッド。ファクトリー名を引数に戻り値としてハッシュを返す。
  let(:params_hash) {attributes_for(:staff_member)}

  describe '#create' do
    example '職員一覧にリダイレクト' do
      post :create, staff_member: params_hash # post 第一引数のメソッドに第二引数をPOSTで送信する。
      expect(response).to redirect_to(admin_staff_members_url) # response アクションの実行結果を保持する。
    end

    example '例外ActionController::ParameterMissingが発生' do
      bypass_rescue # rescue_fromによる例外処理を無効にする。
      expect { post :create }.
        to raise_error(ActionController::ParameterMissing)
    end
  end

  describe '#update' do
    let(:staff_member) { create(:staff_member) }

    example 'suspendedフラグをセットする' do
      params_hash.merge!(suspended: true)
      patch :update, id: staff_member.id, staff_member: params_hash
      staff_member.reload
      expect(staff_member).to be_suspended # be_XXX 述語マッチャー
    end

    example 'hashed_passwordの値は書き換え不可' do
      params_hash.delete(:password)
      params_hash.merge!(hashed_password: 'x')
      expect {
        patch :update, id: staff_member.id, staff_member: params_hash
      }.not_to change {staff_member.hashed_password.to_s } # change 実行前後の値を比較する
    end

  end
end
