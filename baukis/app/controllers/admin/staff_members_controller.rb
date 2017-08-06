class Admin::StaffMembersController < Admin::Base
  def index
    @staff_members = StaffMember.order(:family_name_kana, :given_name_kana)
  end

  def show
    staff_member = StaffMember.find(params[:id]) # id属性値でテーブルからレコードを取得する
    redirect_to [:edit, :admin, staff_member]
    # 引数に配列が指定された場合、配列の要素からルーティング名が推定される。
  end

  def new
    @staff_member = StaffMember.new
  end

  def edit
    @staff_member = StaffMember.find(params[:id])
  end

  def create
    # params[:staff_member]で作成するアカウントのパラメータのハッシュが手に入る
    @staff_member = StaffMember.new(params[:staff_member])
    if @staff_member.save
      flash.notice = '職員アカウントを新規登録しました。'
      redirect_to :admin_staff_members
    else
      render action: 'new'
    end
  end
end
