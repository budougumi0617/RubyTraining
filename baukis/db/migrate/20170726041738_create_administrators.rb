class CreateAdministrators < ActiveRecord::Migration
  def change
    create_table :administrators do |t|
      t.string :email,null: false                       # e-mail address
      t.string :email_for_index, null: false            # e-mail for search
      t.string :hashed_password                         # パスワード
      t.boolean :suspended, null: false, default: false # 停止フラグ

      t.timestamps null: false
    end

    add_index :administrators, :email_for_index, unique: true
  end
end
