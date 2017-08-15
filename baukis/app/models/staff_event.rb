class StaffEvent < ActiveRecord::Base
  # モデル定義でこう書くと、typeカラムから特別な意味が失われ、
  # 普通のカラムとして使用できる。
  self.inheritance_column = nil

  # memberという名前でStaffMemberを参照する。
  # 仮にオブジェクトが@eventにセットされているならば、@event.memberで参照可能。
  # foreign_keyは外部キーの名前。
  belongs_to :member, class_name: 'StaffMember', foreign_key: 'staff_member_id'
  alias_attribute :occurred_at, :created_at

  DESCRIPTIONS = {
    logged_in: 'ログイン',
    logged_out: 'ログアウト',
    rejected: 'ログイン拒否'
  }

  def description
    DESCRIPTIONS[type.to_sym]
  end
end
