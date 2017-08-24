FactoryGirl.define do
  # NOT NULL制約が課せられたcustomer_id属性の値は設定されていない。
  # そのため、利用する際は以下のように記載する必要がある。
  # create(:home_address, customer_id: 1)
  # 外部キー制約を効いているので、上のように宣言するときは
  # 1というidを持つCustomerオブジェクトが既に存在している必要もある。
  # しかし、build(:home_address)と記述してDB未保存のHomeAddressオブジェクトを作ることは問題ない。
  factory :home_address do
    postal_code '1000000'
    prefecture '東京都'
    city '千代田区'
    address1 '試験1-1-1'
    address2 ''
  end

  factory :work_address do
    company_name 'テスト'
    division_name '開発部'
    postal_code '1050000'
    prefecture '東京都'
    city '港区'
    address1 '試験1-1-1'
    address2 ''
  end
end
