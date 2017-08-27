require 'nkf' # Ruby標準の日本語取扱用機能

module StringNormalizer
  extend ActiveSupport::Concern

  def normalize_as_email(text)
    NKF.nkf('-W -w -Z1', text).strip if text
  end

  def normalize_as_name(text)
    NKF.nkf('-W -w -Z1', text).strip if text
  end

  def normalize_as_furigana(text)
    NKF.nkf('-W -w -Z1 --katakana', text).strip if text
  end

  # 郵便番号を正規化する。
  #
  # @param [string] text 郵便番号
  def normalize_as_postal_code(text)
    NKF.nkf('-W -w -Z1', text).strip.gsub(/-/, '') if text
  end

  def normalize_as_phone_number(text)
    NKF.nkf('-W -w -Z1', text).strip if text
  end
end
