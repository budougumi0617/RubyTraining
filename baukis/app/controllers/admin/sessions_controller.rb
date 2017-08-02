class Admin::SessionsController < Admin::Base
  def new
    if current_administrator
      redirect_to :admin_root
    else
      @form = Admin::LoginForm.new
      render action: 'new'
    end
  end

  def create
    @form = Admin::LoginForm.new(params[:admin_login_form])
    if @forms.email.present?
      administrator = Administrator.find_by(email_for_index: @form.email.downcase)
    end
    if administrator
      if administrator.suspended?
        render_action: 'new'
      else
        session[:administrator_id] = administrator.id
        redirect_to :admin_root
      end
    else
      render_action: 'new'
    end
  end

  def destroy
    session.delete(:administrator_id)
    redirect_to :admin_root
  end
end
