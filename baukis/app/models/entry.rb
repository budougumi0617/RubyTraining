class Entry < ActiveRecord::Base
  # 外部キーを通じてモデルを参照する。
  belongs_to :program
  belongs_to :customer
end
