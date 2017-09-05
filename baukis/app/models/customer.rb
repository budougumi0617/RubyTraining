class Customer < ActiveRecord::Base
  include EmailHolder
  include PersonalNameHolder
  include PasswordHolder

  # autosave: true オブジェクトがDBに保存される際に、関連オブジェクトも自動保存される。
  has_one :addresses, dependent: :destroy
  has_one :home_address, autosave: true # モデル間に1対1の相関関係をつける。
  has_one :work_address, autosave: true # Customerが破棄されるときはその前にAddressも破棄する。
  has_many :phones, dependent: :destroy
  # address_idがnilであることを検索条件に指定している。
  has_many :personal_phones, -> { where(address_id: nil).order(:id) },
    class_name: 'Phone', autosave: true
  # Customerが破棄されたらCustomerが申し込んだエントリーも一緒に破棄する。
  has_many :entries, dependent: :destroy
  # has_manyの引数を単数形にした形がsourceオプションの値と等しい場合はsourceオプションを省略することができる。
  # has_many :programs, through: :entries, source: :program
  has_many :programs, through: :entries

  # ActiveRecordのモデルに対するバリデーション
  validates :gender, inclusion: { in: %w(male female), allow_blank: true }
  validates :birthday, date: {
    after: Date.new(1900, 1, 1),
    before: ->(obj) { Date.today },
    allow_blank: true
  }

  # 検索用カラムへ値を反映しておく。
  before_save do
    if birthday
      self.birth_year = birthday.year
      self.birth_month = birthday.month
      self.birth_mday = birthday.mday
    end
  end
end
