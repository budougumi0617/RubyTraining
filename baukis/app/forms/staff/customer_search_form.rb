class Staff::CustomerSearchForm
  include ActiveModel::Model
  include StringNormalizer

  attr_accessor :family_name_kana, :given_name_kana,
    :birth_year, :birth_month, :birth_mday, :gender,
    :address_type, :prefecture, :city, :postal_code, :phone_number,
    :last_four_digits

  def search
    normalize_values

    # whereメソッドは別のRelationオブジェクトを返すので、条件を追加していく。
    rel = Customer
    if family_name_kana.present?
      rel = rel.where(family_name_kana: family_name_kana)
    end
    if given_name_kana.present?
      rel = rel.where(given_name_kana: given_name_kana)
    end
    rel = rel.where(birth_year: birth_year) if birth_year.present?
    rel = rel.where(birth_month: birth_month) if birth_month.present?
    rel = rel.where(birth_mday: birth_mday) if birth_mday.present?
    rel = rel.where(gender: gender) if gender.present?

    # テーブルを結合して、他のテーブルのカラムに基づいてレコードを絞り込む。
    # 単一テーブル継承で同じaddressテーブルに記録することにしたので、条件が単純で済んでいる。
    if prefecture.present? || city.present? || postal_code.present?
      case address_type
      when 'home'
        rel = rel.joins(:home_address)
      when 'work'
        rel = rel.joins(:work_address)
      when ''
        rel = rel.joins(:addresses)
      else
        raise
      end
      if prefecture.present?
        # テーブル名.カラム名
        rel = rel.where('addresses.prefecture' => prefecture)
      end
      rel = rel.where('addresses.city' => city) if city.present?
      if postal_code.present?
        rel = rel.where('addresses.postal_code' => postal_code)
      end
    end

    if phone_number.present? || last_four_digits.present?
      rel = rel.joins(:phones)
      if phone_number.present?
        rel = rel.where('phones.number_for_index' => phone_number)
      end
      if last_four_digits.present?
        rel = rel.where('phones.last_four_digits' => last_four_digits)
      end
    end

    rel = rel.distinct
   # ソート順を決定する。orderメソッドもRelationオブジェクトを返す。
    rel.order(:family_name_kana, :given_name_kana)
  end

  private
  def normalize_values
    self.family_name_kana = normalize_as_furigana(family_name_kana)
    self.given_name_kana = normalize_as_furigana(given_name_kana)
    self.city = normalize_as_name(city)
    self.postal_code = normalize_as_postal_code(postal_code)
    self.phone_number = normalize_as_phone_number(phone_number)
      .try(:gsub, /\D/, '')
  end
end
