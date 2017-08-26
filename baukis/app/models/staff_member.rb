class StaffMember < ActiveRecord::Base
  include EmailHolder
  include PersonalNameHolder
  include PasswordHolder

  # :destroyを指定すると、関連づけられたすべてのStaffEventオブジェクトが、
  # StaffMemberオブジェクトが削除される前に削除される。
  has_many :events, class_name: 'StaffEvent', dependent: :destroy

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

  def active?
    !suspended? && start_date <= Date.today &&
      (end_date.nil? || end_date > Date.today)
  end
end
