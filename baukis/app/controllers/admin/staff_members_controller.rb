class Admin::StaffMembersController < Admin::Base
  before_action :authorize

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
    @staff_member = StaffMember.new(staff_member_params)
    if @staff_member.save
      flash.notice = '職員アカウントを新規登録しました。'
      redirect_to :admin_staff_members
    else
      render action: 'new'
    end
  end

  def update
    @staff_member = StaffMember.find(params[:id])
    # assign_attributesでモデルオブジェクトの属性を一括設定する。
    @staff_member.assign_attributes(staff_member_params)
    if @staff_member.save
      flash.notice = '職員アカウントを更新しました。'
      redirect_to :admin_staff_members
    else
      render action: 'edit'
    end
  end

  def destroy
    @staff_member = StaffMember.find(params[:id])
    @staff_member.destroy!
    flash.notice = '職員アカウントを削除しました。'
    redirect_to :admin_staff_members
  end

  private
  def authorize
    unless current_administrator
      redirect_to :admin_login
    end
  end

  def staff_member_params
    params.require(:staff_member).permit(
      :email, :password, :family_name, :given_name,
      :family_name_kana, :given_name_kana,
      :start_date, :end_date, :suspended
    )
  end
end
