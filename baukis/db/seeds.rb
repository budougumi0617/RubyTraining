common_table_names = %w(hash_locks)
common_table_names.each do |table_name|
  path = Rails.root.join('db', 'seeds', "#{table_name}.rb")
  if File.exist?(path)
    puts "Creating #{table_name}...."
    require(path)
  end
end

table_names = %w(staff_members administrators staff_events customers
  programs entries messages) # 配列を作るときにカンマなどはいらない。

table_names.each do |table_name|
  path = Rails.root.join('db', 'seeds', Rails.env, "#{table_name}.rb")
  if File.exist?(path)
    puts "Creating #{table_name}...."
    require(path)
  end
end
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
