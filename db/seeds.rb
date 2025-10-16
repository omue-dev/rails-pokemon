# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
require 'json'
require 'open-uri'

puts 'Cleaning database...'
Pokeball.destroy_all
Trainer.destroy_all
Pokemon.destroy_all

puts 'Creating trainers...'
ash = Trainer.create!(name: "Ash Ketchum", age: 18)
ash.photo.attach(io: URI.parse('https://upload.wikimedia.org/wikipedia/en/e/e4/Ash_Ketchum_Journeys.png').open, filename: 'ash_ketchum.png', content_type: 'image/png')
puts "Ash has stepped up to the plate!"
misty = Trainer.create!(name: "Misty", age: 20)
misty.photo.attach(io: URI.parse('https://upload.wikimedia.org/wikipedia/en/b/b1/MistyEP.png').open, filename: 'misty.png', content_type: 'image/png')
puts "Misty is ready to go!"
brock = Trainer.create!(name: "Brock", age: 22)
brock.photo.attach(io: URI.parse('https://upload.wikimedia.org/wikipedia/en/7/71/DP-Brock.png').open, filename: 'brock.png', content_type: 'image/png')
puts "Brock is on the scene!"

puts 'Creating pokemons...'
response = URI.parse('https://pokeapi.co/api/v2/pokemon?limit=50').open.read
results = JSON.parse(response)['results']
results.each do |result|
  info = JSON.parse(URI.parse(result['url']).open.read)
  pokemon =Pokemon.create!(name: info['name'].capitalize, element_type: info['types'].first['type']['name'])
  pokemon.photo.attach(io: URI.parse(info['sprites']['front_default']).open, filename: "#{info['name']}.png", content_type: 'image/png')
  puts "Screeahhhhh! #{pokemon.name} created!"
end

puts 'Creating pokeballs...'
towns = ["Vermilion City", "Cerulean City", "Pewter City", "Saffron City", "Celadon City", "Cinnabar Island", "Fuchsia City"]
Trainer.all.each do |trainer|
  Pokemon.all.sample(3).each do |pokemon|
    Pokeball.create!(trainer: trainer, pokemon: pokemon, caught_on: Date.today, location: towns.sample)
    puts "Pokeball created for #{trainer.name} with #{pokemon.name}!"
  end
end


puts "Finished! Created #{Trainer.count} trainers, #{Pokemon.count} pokemons, and #{Pokeball.count} pokeballs."
