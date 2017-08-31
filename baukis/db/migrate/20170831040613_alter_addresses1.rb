class AlterAddresses1 < ActiveRecord::Migration
  def change
    # 住所の検索範囲が限定された場合に使用するインデックス。
    add_index :addresses, [ :type, :prefecture, :city ]
    add_index :addresses, [ :type, :city ]
    # 住所の検索範囲が限定されない場合に使用するインデックス。
    add_index :addresses, [ :prefecture, :city ]
    add_index :addresses, :city
  end
end
