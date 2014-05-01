class Trader < User
  has_many :followships

  def self.best_traders
    @best_traders = []

    self.each do |t|
      next unless t.account and t.account.account_status_records
      account_info = t.account.account_status_records.first
      @best_traders << {:user_name => t.user_name,
                       :equity => account_info.equity,
                       :profit => account_info.profit,
                       :trader_id => t._id}
    end
    @best_traders.sort!{|t1, t2| t2[:profit] <=> t1[:profit]}
  end
end
