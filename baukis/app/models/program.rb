class Program < ActiveRecord::Base
  # 1対多の関連付けを設定している。
  # (Program::destroyが呼ばれたとき、子のEntryもdestroyする。)
  has_many :entries, dependent: :destroy
  # 上で定義されている:entriesを使うと、Entoryで定義されている:customerにアクセスできるので、
  # ２つの関連づけを合成して、:applicantsという新しい関連を定義する。
  has_many :applicants, through: :entries, source: :customer
  belongs_to :registrant, class_name: 'StaffMember'
end
