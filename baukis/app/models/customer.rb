class Customer < ActiveRecord::Base
  include EmailHolder
  include PersonalNameHolder
  include PasswordHolder

  # autosave: true オブジェクトがDBに保存される際に、関連オブジェクトも自動保存される。
  has_one :home_address, dependent: :destroy, autosave: true # モデル間に1対1の相関関係をつける。
  has_one :work_address, dependent: :destroy, autosave: true # Customerが破棄されるときはその前にAddressも破棄する。

  # ActiveRecordのモデルに対するバリデーション
  validates :gender, inclusion: { in: %w(male female), allow_blank: true }
  validates :birthday, date: {
    after: Date.new(1900, 1, 1),
    before: ->(obj) { Date.today },
    allow_blank: true
  }
end
