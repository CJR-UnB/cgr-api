# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

equipe = Team.find_or_create_by!({ name: 'Equipe CJR'})
membro = Role.find_or_create_by!({ name: 'Membro', team: equipe})

cabral = Member.find_or_create_by!({ name: 'João Victor Cabral de Melo'})
MemberRole.find_or_create_by!({member: cabral, role: membro, entry_date: DateTime.now})