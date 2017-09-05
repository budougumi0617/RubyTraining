class Program < ActiveRecord::Base
  # 1対多の関連付けを設定している。
  # (Program::destroyが呼ばれたとき、子のEntryもdestroyする。)
  has_many :entries, dependent: :destroy
  # 上で定義されている:entriesを使うと、Entoryで定義されている:customerにアクセスできるので、
  # ２つの関連づけを合成して、:applicantsという新しい関連を定義する。
  has_many :applicants, through: :entries, source: :customer
  belongs_to :registrant, class_name: 'StaffMember'

  attr_accessor :application_start_date, :application_start_hour,
    :application_start_minute, :application_end_date, :application_end_hour,
    :application_end_minute

  # スコープを使って検索条件を束縛しておく。
  # 第二引数はProcオブジェクト。引数無しなのでこんな感じ
  scope :listing, -> {
    joins('LEFT JOIN entries ON programs.id = entries.program_id') # entriesテーブルを結合して、
      .select('programs.*, COUNT(entries.id) AS number_of_applicants') # テーブルから取得する値
      .group('programs.id') # グループの基準
      .order(application_start_time: :desc)
      .includes(:registrant)
  }
end
