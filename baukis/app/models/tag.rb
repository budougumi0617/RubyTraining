class Tag < ActiveRecord::Base
  has_many :message_tag_links, dependent: :destroy
  # has_many throughでmessage_tag_links経由でmessageと関連付け。
  has_many :messages, through: :message_tag_links
end
