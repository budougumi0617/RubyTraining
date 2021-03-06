class Customer::AccountForm
  include ActiveModel::Model

  attr_accessor :customer, :inputs_home_address, :inputs_work_address
  delegate :persisted?, :valid?, :save, to: :customer # customer.persisted?が呼ばれる。
  # ヘルパーメソッドのform_forがフォーム送信時に使用するHTTPメソッドを
  # 決定するときにpersisted?メソッドが呼ばれる。戻り値が真であれば
  # HTTPメソッドはPATCHに、偽であればPOSTになる。

  def initialize(customer = nil)
    @customer = customer
    (2 - @customer.personal_phones.size).times do
      @customer.personal_phones.build
    end
    self.inputs_home_address = @customer.home_address.present?
    self.inputs_work_address = @customer.work_address.present?
    # build_home_address, build_work_addressは初期状態の
    # 自分のオブジェクトをインスタンス化する。この段階では
    # データベースに保存されない。
    @customer.build_home_address unless @customer.home_address
    @customer.build_work_address unless @customer.work_address
    # 自宅電話番号の数が2個になるまでオブジェクトを関連付ける。
    # personal_phonesにしている操作と同じ。
    (2 - @customer.home_address.phones.size).times do
      @customer.home_address.phones.build
    end
    (2 - @customer.work_address.phones.size).times do
      @customer.work_address.phones.build
    end
  end

  # 以下の様に利用する。params[:form]は:customerなどのキーをもつハッシュ。
  # @customer_form.assign_attributes(params[:form])
  # @paramsにセットしたあとは、プライベートメソッド経由でcustomerにセットしている。
  # こうすることで、バリデーションを経由することができる。
  def assign_attributes(params = {})
    @params = params
    self.inputs_home_address = params[:inputs_home_address].in? [ '1', 'true' ]
    self.inputs_work_address = params[:inputs_work_address].in? [ '1', 'true' ]

    customer.assign_attributes(customer_params)

    phones = phone_params(:customer).fetch(:phones)
    customer.personal_phones.size.times do |index|
      attributes = phones[index.to_s]
      if attributes && attributes[:number].present?
        customer.personal_phones[index].assign_attributes(attributes)
      else
        customer.personal_phones[index].mark_for_destruction
      end
    end

    if inputs_home_address
      customer.home_address.assign_attributes(home_address_params)

      phones = phone_params(:home_address).fetch(:phones)
      customer.home_address.phones.size.times do |index|
        attributes = phones[index.to_s]
        if attributes && attributes[:number].present?
          customer.home_address.phones[index].assign_attributes(attributes)
        else
          customer.home_address.phones[index].mark_for_destruction
        end
      end
    else
      # 削除対象というマーキングをする。
      # https://apidock.com/rails/ActiveRecord/AutosaveAssociation/mark_for_destruction
      customer.home_address.mark_for_destruction
    end
    if inputs_work_address
      customer.work_address.assign_attributes(work_address_params)

      phones = phone_params(:work_address).fetch(:phones)
      customer.work_address.phones.size.times do |index|
        attributes = phones[index.to_s]
        if attributes && attributes[:number].present?
          customer.work_address.phones[index].assign_attributes(attributes)
        else
          customer.work_address.phones[index].mark_for_destruction
        end
      end
    else
      customer.work_address.mark_for_destruction
    end
  end

  # 以下はCustomerオブジェクトの宣言内でautosave: trueにしたので不要になった。
  # def valid?
  #   # { x, y, z }.map { |e| e.valid? }.all? と同じような書き方。
  #   # &をシンボルにつけるとひとつの引数を取るブロックに変換される。
  #   [ customer, customer.home_address, customer.work_address ]
  #     .map(&:valid?).all?
  # end

  # delegateでsaveメソッドをCutomerに移譲したので不要になった。
  # 明示的に3つのオブジェクトを保存する。
  # def save
  #   if valid?
  #    ActiveRecord::Base.transaction do # ブロック内をひとつのDB操作として担保できる。
  #      # モデルオブジェクトのsave!メソッドは感嘆符なしのsaveメソッドと異なり、
  #      # バリデーションに失敗すると例外ActiveRecord::RecordInvalidを発生させる。
  #      customer.save!
  #      customer.home_address.save!
  #      customer.work_address.save!
  #    end
  #  end
  # end

  private

  # 各バリデーションメソッド。
  def customer_params
    @params.require(:customer).permit(
      :email,
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

  def phone_params(record_name)
    @params.require(record_name).permit(phones: [ :number, :primary ])
  end
end
