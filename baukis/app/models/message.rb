class Message < ActiveRecord::Base
  # 問い合わせの場合は:customerが送信者。職員からの返信の場合は、:customerがメッセージの宛先。
  belongs_to :customer
  belongs_to :staff_member
  belongs_to :root, class_name: 'Message', foreign_key: 'root_id'
  belongs_to :parent, class_name: 'Message', foreign_key: 'parent_id'

  validates :subject, :body, presence: true
  validates :subject, length: { maximum: 80, allow_blank: true }
  validates :body, length: { maximum: 800, allow_blank: true }

  before_create do
    if parent
      self.customer = parent.customer
      self.root = parent.root || parent
    end
  end

  # 検索時にデフォルトで適用されるスコープ。なお、この検索条件はunscopeメソッドで打ち消せる。
  # ソートの順序を上書きするには、reorderメソッドを用いる。
  default_scope { order(created_at: :desc) }

  before_validation do
    if parent
      self.root = parent.root || parent
      self.customer = parent.customer
    end
  end

  attr_accessor :child_nodes

  def tree
    return @tree if @tree # 遅延初期化。
    r = root || self
    messages = Message.where(root_id: r.id).select(:id, :parent_id, :subject)
    @tree = SimpleTree.new(r, messages)
  end
end
