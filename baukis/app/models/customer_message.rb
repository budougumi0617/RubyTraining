class CustomerMessage < Message
  # 特定のメッセージのみを抽出するためのスコープ。
  scope :unprocessed, -> { where(status: 'new', deleted: false) }
end
