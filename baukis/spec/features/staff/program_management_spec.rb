require 'rails_helper'

feature 'プログラム管理機能', :performance do
  include FeaturesSpecHelper
  include PerformanceSpecHelper
  let(:staff_member) { create(:staff_member) }

  before do
    # プログラムの登録
    20.times do |n|
      p = create(:program, application_start_time: n.days.ago.midnight)
      if n < 2
        p.applicants << create(:customer)
        p.applicants << create(:customer)
      end
    end

    switch_namespace(:staff)
    login_as_staff_member(staff_member)
  end

  # ブロック引数をエグザンプルオブジェクトと呼ぶ。
  # エグザンプルのメタデータを保持している。write_to_performance_logの中で名前などを取得するのに利用する。
  scenario 'プログラム一覧' do |example|
    visit staff_programs_path
    expect(page).to have_css('h1', text: 'プログラム管理')

    # 与えられたブロックの実行時間を計測する。
    elapsed = Benchmark.realtime do
      100.times do
        visit staff_programs_path
      end
    end

    write_to_performance_log(example, elapsed)
    expect(elapsed).to be < 100.0
  end
end
