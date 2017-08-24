module FeaturesSpecHelper
  # /config/environments/test.rb に記載されたホスト名をCapybaraに設定する。
  def switch_namespace(namespace)
    config = Rails.application.config.baukis
    Capybara.app_host = 'http://' + config[namespace][:host]
  end

  # 職員としてログインする。
  def login_as_staff_member(staff_member, password = 'pw')
    visit staff_login_path # Rails側で定義されたヘルパーメソッド
    within('#login-form') do
      fill_in 'メールアドレス', with: staff_member.email
      fill_in 'パスワード', with: password
      click_button 'ログイン'
    end
  end
end
