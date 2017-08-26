class Customer < ActiveRecord::Base
  include EmailHolder
  include PersonalNameHolder

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


  def password=(raw_password)
    if raw_password.kind_of?(String)
      self.hashed_password = BCrypt::Password.create(raw_password)
    elsif raw_password.nil?
      self.hashed_password = nil
    end
  end
end
