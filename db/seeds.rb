# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

demo_trader1 = Trader.create(:user_name => 'demo_trader1', :password => Digest::MD5.hexdigest('foobar'), :email => 'demo_trader1@example.com', :created_time => DateTime.current)
demo_trader1_account = demo_trader1.create_account(:account_number => '1')
demo_trader1_account.account_status_records.create(:equity => 200000.0, :profit => 30.0)

demo_trader2 = Trader.create(:user_name => 'demo_trader2', :password => Digest::MD5.hexdigest('foobar'), :email => 'demo_trader2@example.com', :created_time => DateTime.current)
demo_trader2_account = demo_trader2.create_account(:account_number => '1')
demo_trader2_account.account_status_records.create(:equity => 170000.0, :profit => 25.0)

demo_trader3 = Trader.create(:user_name => 'demo_trader3', :password => Digest::MD5.hexdigest('foobar'), :email => 'demo_trader3@example.com', :created_time => DateTime.current)
demo_trader3_account = demo_trader3.create_account(:account_number => '1')
demo_trader3_account.account_status_records.create(:equity => 120000.0, :profit => 32.0)

demo_follower1 = Follower.create(:user_name => 'demo_follower', :password => Digest::MD5.hexdigest('foobar'), :email => 'demo_follower@example.com', :created_time => DateTime.current)
demo_follower1_account = demo_follower1.create_account(:account_number => '1')
demo_follower1_account.account_status_records.create(:equity => 10000.0, :profit => 10.0)
