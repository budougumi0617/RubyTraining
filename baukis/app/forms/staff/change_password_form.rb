class Staff::ChangePasswordForm
  include ActiveModel::Model

  attr_accessor :object, # StaffMemberオブジェクトを入れる
                :current_password, :new_password,
                :new_password_confirmation # 確認用のパスワード入力欄

  validates :new_password, presence: true, confirmation: true

  validate do
    unless Staff::Authenticator.new(object).authenticate(current_password)
      errors.add(:current_password, :wrong)
    end
  end

  def save
    object.password = new_password
    object.save!
  end
end
