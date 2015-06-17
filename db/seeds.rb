# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

#Students
User.create(email: 'user@student.nl',password: '12345678', password_confirmation: '12345678', first_name: 'user', surname: 'student', activated: true)
User.create(email: 'emmasteen@student.nl',password: '12345678', password_confirmation: '12345678', first_name: 'emma', surname: 'steen', activated: true)
User.create(email: 'nikolaaskooi@student.nl',password: '12345678', password_confirmation: '12345678', first_name: 'nikolaas', surname: 'kooi', activated: true)
User.create(email: 'sophiedraaijer@student.nl',password: '12345678', password_confirmation: '12345678', first_name: 'sophie', surname: 'draaijer', activated: true)
User.create(email: 'stevenzeemeeuw@student.nl',password: '12345678', password_confirmation: '12345678', first_name: 'steven', surname: 'zeemeeuw', activated: true)
User.create(email: 'johnnygeld@student.nl',password: '12345678', password_confirmation: '12345678', first_name: 'johnny', surname: 'geld', activated: true)
User.create(email: 'theongrijsgenot@student.nl',password: '12345678', password_confirmation: '12345678', first_name: 'theon', surname: 'grijsgenot', activated: true)
User.create(email: 'peterkleinevinger@student.nl',password: '12345678', password_confirmation: '12345678', first_name: 'peter', surname: 'kleinevinger', activated: true)
User.create(email: 'freddiekwik@student.nl',password: '12345678', password_confirmation: '12345678', first_name: 'freddie', surname: 'kwik', activated: true)

#Teachers
User.create(email: 'admin@teacher.nl',password: '12345678', password_confirmation: '12345678', first_name: 'admin', surname: 'teacher', activated: true, role: 'admin')
User.create(email: 'johnpijn@teacher.nl',password: '12345678', password_confirmation: '12345678', first_name: 'john', surname: 'pijn', activated: true, role: 'admin')
User.create(email: 'asaboterveld@teacher.nl',password: '12345678', password_confirmation: '12345678', first_name: 'asa', surname: 'boterveld', activated: true, role: 'admin')
User.create(email: 'meganvos@teacher.nl',password: '12345678', password_confirmation: '12345678', first_name: 'megan', surname: 'vos', activated: true, role: 'admin')

#Superadmins
User.create(email: 'superadmin@teacher.nl',password: '12345678', password_confirmation: '12345678', first_name: 'super',suffix: 'admin', surname: 'teacher', activated: true, role: 'superadmin')

#scenario sessions
ScenarioSession.create(scenario_id: 1, student_id: 5, teacher_id: 14)

#Messages inbox
Message.create(content: "Briefing voor project iHuman", sender_id: 14, scenario_session_id: 1, role: "Programmeur")
Message.create(content: "Hallo Steven Zeemeeuw! ...", sender_id: 14, scenario_session_id: 1, role: "Programmeur")
Message.create(content: "Dit is een coole app!", sender_id: 14, scenario_session_id: 1, role: "Programmeur")
Message.create(content: "Nog meer uitroep tekens!!!!", sender_id: 14, scenario_session_id: 1, role: "Programmeur")

#Messages outbox

#Scenarios
Scenario.create()
