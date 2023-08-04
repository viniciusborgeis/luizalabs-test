# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

puts 'creating users...'

users_data = [
  { email: 'cezar@test.com', password: '123456', name: 'Cezar', role: 'athlete' },
  { email: 'pablo@test.com', password: '123456', name: 'Pablo', role: 'athlete' },
  { email: 'ramon@test.com', password: '123456', name: 'Ramon', role: 'athlete' },
  { email: 'committee@test.com', password: '123456', name: 'Committee', role: 'committee' }
]

users = User.create(users_data)

puts "Users created: #{users.map(&:name).join(', ')}"
puts '*' * 50
puts ''

puts 'creating modalities...'

modality_data = [
  { name: '100m rasos', unit: 'seconds' },
  { name: 'Lançamento de Dardo', unit: 'meters' }
]

modalities = Modality.create(modality_data)

puts "Modalities created: #{modalities.map(&:name).join(', ')}"
puts '*' * 50
puts ''

puts 'creating competitions...'

competitions_data = [
  { name: 'Corrida olímpica 1', modality_id: modalities.first.id, user_id: users.last.id, closed: false },
  { name: 'Corrida olímpica 2', modality_id: modalities.first.id, user_id: users.last.id, closed: false },
  { name: 'Corrida olímpica 3', modality_id: modalities.first.id, user_id: users.last.id, closed: false },
  { name: 'Dardo olímpico 1', modality_id: modalities.last.id, user_id: users.last.id, closed: false },
  { name: 'Dardo olímpico 2', modality_id: modalities.last.id, user_id: users.last.id, closed: false },
  { name: 'Dardo olímpico 3', modality_id: modalities.last.id, user_id: users.last.id, closed: false }
]

competitions = Competition.create(competitions_data)

puts "Competitions created: #{competitions.map(&:name).join(', ')}"
puts '*' * 50
puts ''

puts 'creating results...'

results_data = [
  { value: 10.0, user_id: users.first.id, competition_id: competitions.first.id },
  { value: 11.0, user_id: users.second.id, competition_id: competitions.first.id },
  { value: 12.0, user_id: users.third.id, competition_id: competitions.first.id },
  { value: 13.0, user_id: users.second.id, competition_id: competitions.second.id },
  { value: 18.0, user_id: users.third.id, competition_id: competitions.second.id },
  { value: 15.0, user_id: users.first.id, competition_id: competitions.second.id },
  { value: 20.0, user_id: users.third.id, competition_id: competitions.third.id },
  { value: 21.0, user_id: users.first.id, competition_id: competitions.third.id },
  { value: 22.0, user_id: users.second.id, competition_id: competitions.third.id },
  { value: 23.0, user_id: users.first.id, competition_id: competitions.fourth.id },
  { value: 24.0, user_id: users.second.id, competition_id: competitions.fourth.id },
  { value: 25.0, user_id: users.third.id, competition_id: competitions.fourth.id },
  { value: 26.0, user_id: users.first.id, competition_id: competitions.fifth.id },
  { value: 27.0, user_id: users.second.id, competition_id: competitions.fifth.id },
  { value: 28.0, user_id: users.third.id, competition_id: competitions.fifth.id },
  { value: 29.0, user_id: users.first.id, competition_id: competitions.last.id },
  { value: 30.0, user_id: users.second.id, competition_id: competitions.last.id },
  { value: 31.0, user_id: users.third.id, competition_id: competitions.last.id }
]

results = Result.create(results_data)

puts "Results created: #{results.map(&:value).join(', ')}"
puts '*' * 50
puts ''

puts 'closing competitions...'

competitions.second.update(closed: true)
competitions.fifth.update(closed: true)

puts "Competitions closed: #{competitions.second.name} and #{competitions.fifth.name}"
puts '*' * 50
puts ''

puts 'seeds done!'
