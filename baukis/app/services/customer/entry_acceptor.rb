class Customer::EntryAcceptor
  def initialize(customer)
    @customer = customer
  end

  def accept(program)
    raise if Time.current < program.application_start_time
    return :closed if Time.current >= program.application_end_time
    ActiveRecord::Base.transaction do
      # トランザクションを始めた後、対象のモデルオブジェクトの
      # インスタンスメソッドのlock!を呼ぶことでテーブルレコードの排他的ロックを取得できる。
      # ロックはトランザクションが終了するまで続く。
      # ただし、これはモデル間に正しく外部キー制約を設定している場合に限る。
      program.lock!
      # 二重申し込み防止。
      if program.entries.where(customer_id: @customer.id).exists?
        return :accepted
      elsif max = program.max_number_of_participants
        if program.entries.where(canceled: false).count < max
          program.entries.create!(customer: @customer)
          return :accepted
        else
          return :full
        end
      else
        program.entries.create!(customer: @customer)
        return :accepted
      end
    end
  end
end
