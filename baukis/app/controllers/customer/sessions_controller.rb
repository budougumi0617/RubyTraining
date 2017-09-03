class Customer::SessionsController < Customer::Base
  skip_before_action :authorize

  def new
    if current_customer
      redirect_to :customer_root
    else
      @form = Customer::LoginForm.new
      render action: 'new'
    end
  end

  def create
    @form = Customer::LoginForm.new(params[:customer_login_form])
    if @form.email.present?
      customer = Customer.find_by(email_for_index: @form.email.downcase)
    end
    if Customer::Authenticator.new(customer).authenticate(@form.password)
      if @form.remember_me?
        # 閲覧不可、変更不可、永続的に情報を残すときは、以下のように記述する。
        # デフォルト設定では、有効期限は20年。1週間後までにする場合は以下のように書く。
        # cookies.signed[:customer_id] = {
        #   value: customer.id,
        #   expires: 1.week.from_now
        # }
        cookies.permanent.signed[:customer_id] = customer.id
      else
        cookies.delete(:customer_id)
        session[:customer_id] = customer.id
      end
      flash.notice = 'ログインしました。'
      redirect_to :customer_root
    else
      flash.now.alert = 'メールアドレスまたはパスワードが正しくありません。'
      render action: 'new'
    end
  end

  def destroy
    cookies.delete(:customer_id)
    session.delete(:customer_id)
    flash.notice = 'ログアウトしました。'
    redirect_to :customer_root
  end
end
