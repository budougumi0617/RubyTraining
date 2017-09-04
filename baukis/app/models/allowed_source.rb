class AllowedSource < ActiveRecord::Base
  attr_accessor :last_octet

  # アスタリスクが設定されていた場合は、ワイルドカードをフラグを立てる。
  before_validation do
    if last_octet
      self.last_octet.strip!
      if last_octet == '*'
        self.octet4 = 0
        self.wildcard = true
      else
        self.octet4 = last_octet
      end
    end
  end

  # まとめてvalidation設定
  validates :octet1, :octet2, :octet3, :octet4, presence: true,
    numericality: { only_integer: true, allow_blank: true },
    inclusion: { in: 0..255, allow_blank: true }
  validates :octet4,
    uniqueness: { scope: [ :octet1, :octet2, :octet3 ], allow_blank: true }
  # 0-255以外に'*'も許可リストに加える。
  validates :last_octet,
    inclusion: { in: (0..255).to_a.map(&:to_s) + [ '*' ], allow_blank: true }

  after_validation do
    # octet4に対応する入力欄がフォーム上に存在しないため、last_octet属性のエラーとしてしまう。
    if last_octet
      errors[:octet4].each do |message|
        errors.add(:last_octet, message)
      end
    end
  end

  # 文字列でIPアドレスを指定できるようにする。
  def ip_address=(ip_address)
    octets = ip_address.split('.')
    self.octet1 = octets[0]
    self.octet2 = octets[1]
    self.octet3 = octets[2]
    if octets[3] == '*'
      self.octet4 = 0
      self.wildcard = true
    else
      self.octet4 = octets[3]
    end
  end

  class << self
    def include?(namespace, ip_address)
      !Rails.application.config.baukis[:restrict_ip_addresses] ||
        where(namespace: namespace).where(options_for(ip_address)).exists?
    end

    private
    def options_for(ip_address)
      octets = ip_address.split('.')
      condition = %Q{
        octet1 = ? AND octet2 = ? AND octet3 = ?
        AND ((octet4 = ? AND wildcard = ?) OR wildcard = ?)
      }.gsub(/\s+/, ' ').strip
      [ condition, *octets, false, true ]
    end
  end
end
