class UpdateCustomers1 < ActiveRecord::Migration
  # create, add系のメソッドはchangeで使えるが、（進め方を定義するだけでOK）
  # executeは明示的にup, downを定義する必要がある。
  # マイグレーションを進める処理。
  def up
    execute(%q{
      UPDATE customers SET birth_year = EXTRACT(YEAR FROM birthday),
        birth_month = EXTRACT(MONTH FROM birthday),
        birth_mday = EXTRACT(DAY FROM birthday)
        WHERE birthday IS NOT NULL
    })
  end

  # マイグレーションを取り消す（ロールバックする）処理。
  # ロールバック処理ができないマイグレーションは以下の例外を発生させる。
  # raise ActiveRecord::IrreversibleMigration
  def down
    execute(%q{
      UPDATE customers SET birth_year = NULL,
        birth_month = NULL,
        birth_mday = NULL
    })
  end
end
