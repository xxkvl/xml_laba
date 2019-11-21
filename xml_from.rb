require 'nokogiri'
require 'sinatra/activerecord'

ActiveRecord::Base.establish_connection(
  adapter: 'sqlite3',
  database: 'db/data.sqlite3',
  pool: 5,
  timeout: 5000
)

class Movie < ActiveRecord::Base
  validates :title, presence: true
  validates :director, presence: true
end
f = File.open("test.xml")
xml = Nokogiri::XML(f)


m = Movie.new(title: xml.at('title').text, director: xml.at('director').text)
m.save!

p m.title
p m.director
