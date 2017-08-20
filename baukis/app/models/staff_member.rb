class StaffMember < ActiveRecord::Base
  include StringNormalizer
  # :destroyを指定すると、関連づけられたすべてのStaffEventオブジェクトが、
  # StaffMemberオブジェクトが削除される前に削除される。
  has_many :events, class_name: 'StaffEvent', dependent: :destroy

  before_validation do
    self.email = normalize_as_email(email)
    self.email_for_index = email.downcase if email
    self.family_name = normalize_as_name(family_name)
    self.given_name = normalize_as_name(given_name)
    self.family_name_kana = normalize_as_furigana(family_name_kana)
    self.given_name_kana = normalize_as_furigana(given_name_kana)
  end

  KATAKANA_REGEXP = /\A[\p{katakana}\u{30fc}]+\z/

  validates :email, presence: true, email: { allow_blank: true }
  validates :family_name, :given_name, presence: true # 値が空だと失敗
  validates :family_name_kana, :given_name_kana, presence: true,
    format: { with: KATAKANA_REGEXP, allow_blank: true } # 値が空の場合はバリデーションをスキップ
  validates :start_date, presence: true, date: {
    after_or_equal_to: Date.new(2000, 1, 1), # 指定された日を含む
    # procオブジェクトを作って毎回呼び出さないと、日付が起動時に固定されてしまう。
    before: ->(obj) { 1.year.from_now.to_date }, # 指定された日は含まない
    allow_blank: true # trueの場合は空白を許可する。
  }
  validates :end_date, date: {
    after: :start_date, # 指定された日は含まない
    before: ->(obj) { 1.year.from_now.to_date },
    allow_blank: true
  }

  validates :email_for_index, uniqueness: { allow_blank: true }
  after_validation do
    if errors.include?(:email_for_index)
      errors.add(:email, :taken)
      errors.delete(:email_for_index)
    end
  end

  def password=(raw_password)
    if raw_password.kind_of?(String)
      self.hashed_password = BCrypt::Password.create(raw_password)
    elsif raw_password.nil?
      self.hashed_password = nil
    end
  end

  def active?
    !suspended? && start_date <= Date.today &&
      (end_date.nil? || end_date > Date.today)
  end
end
