require 'nokogiri'
require 'sinatra/activerecord'

ActiveRecord::Base.establish_connection(
  adapter: 'sqlite3',
  database: 'db/data.sqlite3',
  pool: 5,
  timeout: 5000
)

class CreateMovies < ActiveRecord::Migration[5.2]
  def change
    create_table :movies do |t|
      t.string :title, null: false
      t.string :director, null: false

      t.timestamps
    end
  end
end


class Movie < ActiveRecord::Base
  validates :title, presence: true
  validates :director, presence: true
end


print "Give me the title of the movie: "
title = gets.chomp

print "Give me the director of the movie: "
director = gets.chomp

movie = Movie.new(title: title, director: director)
movie.save!

builder = Nokogiri::XML::Builder.new(:encoding => 'UTF-8') do |xml|
  xml.root {
    xml.movie {
      xml.widget {
        xml.id_ movie.id
        xml.title movie.title
        xml.director movie.director
      }
    }
  }
end

File.open('test.xml', 'w') { |file| file.write(builder.to_xml) }