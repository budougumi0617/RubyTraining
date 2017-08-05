class Admin::StaffMembersController < Admin::Base
  def index
    @staff_members = StaffMember.order(:family_name_kana, :given_name_kana)
  end

  def show
    staff_member = StaffMember.find(params[:id]) # id属性値でテーブルからレコードを取得する
    redirect_to [:edit, :admin, staff_member]
    # 引数に配列が指定された場合、配列の要素からルーティング名が推定される。
  end
end
