# Standard role and team for members registrated without any role 
#
visitantes = Team.find_or_create_by!({ name: 'Visitantes'})
Role.find_or_create_by!({ name: 'Visitante', team: visitantes})

# Samples
#
equipe = Team.find_or_create_by!({ name: 'Equipe CJR'})
membro = Role.find_or_create_by!({ name: 'Membro', team: equipe})

cabral = Member.find_or_create_by!({ name: 'João Victor Cabral de Melo'})
MemberRole.find_or_create_by!({member: cabral, role: membro, entry_date: DateTime.now})