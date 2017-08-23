class Staff::CustomerForm
  include ActiveModel::Model

  attr_accessor :customer
  delegate :persisted?, to: :customer # customer.persisted?が呼ばれる。
  # ヘルパーメソッドのform_forがフォーム送信時に使用するHTTPメソッドを
  # 決定するときにpersisted?メソッドが呼ばれる。戻り値が真であれば
  # HTTPメソッドはPATCHに、偽であればPOSTになる。

  def initialize(customer = nil)
    @customer = customer
    @customer ||= Customer.new(gender: 'male')
    @customer.build_home_address unless @customer.home_address
    @customer.build_work_address unless @customer.work_address
    # build_home_address, build_work_addressは初期状態の
    # 自分のオブジェクトをインスタンス化する。この段階では
    # データベースに保存されない。
  end

  # 以下の様に利用する。params[:form]は:customerなどのキーをもつハッシュ。
  # @customer_form.assign_attributes(params[:form])
  # @paramsにセットしたあとは、プライベートメソッド経由でcustomerにセットしている。
  # こうすることで、バリデーションを経由することができる。
  def assign_attributes(params = {})
    @params = params

    customer.assign_attributes(customer_params)
    customer.home_address.assign_attributes(home_address_params)
    customer.work_address.assign_attributes(work_address_params)
  end

  # 明示的に3つのオブジェクトを保存する。
  def save
    ActiveRecord::Base.transaction do # ブロック内をひとつのDB操作として担保できる。
      customer.save!
      customer.home_address.save!
      customer.work_address.save!
    end
  end

  private

  # 各バリデーションメソッド。
  def customer_params
    @params.require(:customer).permit(
      :email, :password,
      :family_name, :given_name, :family_name_kana, :given_name_kana,
      :birthday, :gender
    )
  end

  def home_address_params
    @params.require(:home_address).permit(
      :postal_code, :prefecture, :city, :address1, :address2,
    )
  end

  def work_address_params
    @params.require(:work_address).permit(
      :postal_code, :prefecture, :city, :address1, :address2,
      :company_name, :division_name
    )
  end

end
