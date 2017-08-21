class Customer < ActiveRecord::Base
  has_one :home_address, dependent: :destroy # モデル間に1対1の相関関係をつける。
  has_one :work_address, dependent: :destroy # Customerが破棄されるときはその前にAddressも破棄する。

  before_validation do
    self.email_for_index = email.downcase if email
  end

  def password=(raw_password)
    if raw_password.kind_of?(String)
      self.hashed_password = BCrypt::Password.create(raw_password)
    elsif raw_password.nil?
      self.hashed_password = nil
    end
  end
end
