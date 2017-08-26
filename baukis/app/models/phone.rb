class Phone < ActiveRecord::Base
  include StringNormalizer

  belongs_to :customer
  belongs_to :address

  before_validation do
    self.number = normalize_as_phone_number(number)
    self.number_for_index = number.gsub(/\D/, '') if number
  end

  # 初回保存時前に行われる処理。
  before_create do
    self.customer = address.customer if address
  end

  validates :number, presence: true,
    format: { with: /\A\+?\d+(-\d+)*\z/, allow_blank: true }
end
