require 'csv'
tracking_sheet = CSV.read('Pomtracker.csv', headers:true)

CSV.foreach('Pomtracker.csv') do |row|
  puts row.inspect
end
