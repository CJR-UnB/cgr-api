# Admin user
admin = User.create!({name: 'admin', 
        email: 'admin@admin.com', 
        password: 'popao123',
        password_confirmation: 'popao123',
        admin: true})

# Standard role and team for members registrated without any role 
visitantes = Team.find_or_create_by!({ name: 'Visitantes'})
Role.find_or_create_by!({ name: 'Visitante', team: visitantes})

# Samples
equipe = Team.find_or_create_by!({ name: 'Equipe CJR'})
membro = Role.find_or_create_by!({ name: 'Membro', team: equipe})

cabral = Member.find_or_create_by!({ name: 'João Victor Cabral de Melo'})
MemberRole.find_or_create_by!({member: cabral, role: membro, entry_date: DateTime.now})

# Users basics
User.create!({name: 'Azul', 
        email: 'azul@noe.com', 
        password: 'popao123',
        password_confirmation: 'popao123',
        admin: true})

User.create!({name: 'Dapedu', 
        email: 'dapedu@noe.com', 
        password: 'popao123',
        password_confirmation: 'popao123',
        admin: true})

User.create!({name: 'Alice', 
        email: 'alice@noe.com', 
        password: 'popao123',
        password_confirmation: 'popao123',
        admin: false})

User.create!({name: 'Neiralay', 
        email: 'neiralay@noe.com', 
        password: 'popao123',
        password_confirmation: 'popao123',
        admin: false})

User.create!({name: 'Thisgo', 
        email: 'thisgo@noe.com', 
        password: 'popao123',
        password_confirmation: 'popao123',
        admin: true})

User.create!({name: 'Sorriso', 
        email: 'sorriso@noe.com', 
        password: 'popao123',
        password_confirmation: 'popao123',
        admin: true})

User.create!({name: 'Gustavo', 
        email: 'gustavo@noe.com', 
        password: 'popao123',
        password_confirmation: 'popao123',
        admin: false})

#Teams for tests
cgr = Team.find_or_create_by!({ name: 'Equipe CGR'})
ilcaffe = Team.find_or_create_by!({ name: 'Equipe ilcaffe'})

#test roles
devCgr = Role.find_or_create_by!({ name: 'Dev', team: cgr})
gerenteCgr = Role.find_or_create_by!({ name: 'Gerente', team: cgr})
negociadorCgr = Role.find_or_create_by!({ name: 'Negociador', team: cgr})

devIlcaffe = Role.find_or_create_by!({ name: 'Dev', team: ilcaffe})
gerenteIlcaffe = Role.find_or_create_by!({ name: 'Gerente', team: ilcaffe})
negociadorIlcaffe = Role.find_or_create_by!({ name: 'Negociador', team: ilcaffe})

#test members

dapedu = Member.find_or_create_by!({ name: 'Dapedu'})
MemberRole.find_or_create_by!({member: dapedu, role: gerenteCgr, entry_date: DateTime.now})

azul = Member.find_or_create_by!({ name: 'Azul'})
MemberRole.find_or_create_by!({member: azul, role: devCgr, entry_date: DateTime.now})

sorriso = Member.find_or_create_by!({ name: 'Sorriso'})
MemberRole.find_or_create_by!({member: sorriso, role: devCgr, entry_date: DateTime.now})

thisgo = Member.find_or_create_by!({ name: 'Thisgo'})
MemberRole.find_or_create_by!({member: thisgo, role: devCgr, entry_date: DateTime.now})

alice = Member.find_or_create_by!({ name: 'Alice'})
MemberRole.find_or_create_by!({member: alice, role: gerenteIlcaffe, entry_date: DateTime.now})

neiralay = Member.find_or_create_by!({ name: 'Neiralay'})
MemberRole.find_or_create_by!({member: neiralay, role: devIlcaffe, entry_date: DateTime.now})

gustavo = Member.find_or_create_by!({ name: 'Gustavo'})
MemberRole.find_or_create_by!({member: gustavo, role: devIlcaffe, entry_date: DateTime.now})

#tests payment
cash = Payment.find_or_create_by!({ amount: 3000, payed:true, payment_date:''})
cash2 = Payment.find_or_create_by!({ amount: 1500, payed:false, payment_date:''})

#tests projects 
nameProject = Team.find_by_name("Equipe CGR").id
Project.find_or_create_by!({ team_id: nameProject ,name:'CGR',client_info:'',project_info:''})
nameProject2 = Team.find_by_name('Equipe ilcaffe').id
Project.find_or_create_by!({ team_id: nameProject2, payment_id: cash,name:'IlCaffé',client_info:'',project_info:''})
