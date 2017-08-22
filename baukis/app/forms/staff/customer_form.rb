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
end
