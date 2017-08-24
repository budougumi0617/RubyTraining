FactoryGirl.define do
  factory :customer do
    sequence(:email) { |n| "member#{n}@example.jp" }
    family_name '山田'
    given_name '太郎'
    family_name_kana 'ヤマダ'
    given_name_kana 'タロウ'
    password 'pw'
    birthday Date.new(1970, 1, 1)
    gender 'male'
    # モデルの関連付けを行う。
    # associationメソッドの第1引数にファクトリー名前を指定している。
    # strategyオプションを指定しないと、通常createで作成される。
    # (buildならDBに保存されない。)
    # buildメソッドで作られた各AddressオブジェクトはCustomerオブジェクトが保存される際に、
    # 合わせて保存される。
    association :home_address, strategy: :build
    association :work_address, strategy: :build
  end
end
