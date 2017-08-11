shared_examples 'a protected staff controller' do
  describe '#index' do
    example 'ログインフォームにリダイレクト' do
      get :index
      expect(response).to redirect_to(staff_login_url)
    end
  end

  describe '#show' do
    example 'ログインフォームにリダイレクト' do
      get :show, id: 1 # id 1 を引数にshowページをGET
      expect(response).to redirect_to(staff_login_url)
    end
  end
end

shared_examples 'a protected singular staff controller' do
  describe '#show' do
    example 'ログインフォームにリダイレクト' do
      get :show
      expect(response).to redirect_to(staff_login_url)
    end
  end
end
