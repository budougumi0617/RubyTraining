class Staff::MessagesController < Staff::Base
  # アクセス制限のためのアクション
  before_action :reject_non_xhr, only: [ :count ]

  # GET
  def count
    render text: CustomerMessage.unprocessed.count
  end
end
