# frozen_string_literal: true

# template example of has_many :through, based on Rails docs
# https://edgeguides.rubyonrails.org/association_basics.html
# section 2.4 The has_many :through Association

DB_SEEDS_CONTENT = <<~'SEEDS'
  Patient.create(name: "Joe Johnson")
  Patient.create(name: "Sara Smith")
  Patient.create(name: "Kim Leopard")

  Doctor.create(name: "Dr. Jackson")
  Doctor.create(name: "Dr. Richards")
  Doctor.create(name: "Dr. Louis")

  Appointment.create(patient_id: 1, doctor_id: 1, scheduled: DateTime.now + 1.day)
  Appointment.create(patient_id: 2, doctor_id: 2, scheduled: DateTime.now + 2.days)
  Appointment.create(patient_id: 3, doctor_id: 3, scheduled: DateTime.now + 3.days)
  Appointment.create(patient_id: 1, doctor_id: 3, scheduled: DateTime.now + 4.days)
  Appointment.create(patient_id: 2, doctor_id: 3, scheduled: DateTime.now + 5.days)
  Appointment.create(patient_id: 1, doctor_id: 2, scheduled: DateTime.now + 6.days)
SEEDS

PATIENT_HAS_MANY_DOCTORS_ASSOCIATION = <<-RUBY
  has_many :appointments
  has_many :doctors, through: :appointments
RUBY

DOCTOR_HAS_MANY_PATIENTS_ASSOCATION = <<-RUBY
  has_many :appointments
  has_many :patients, through: :appointments
RUBY

DB_SEEDS_FILENAME = 'db/seeds.rb'

def initialize_db
  create_file(DB_SEEDS_FILENAME, force: true)
  append_to_file(DB_SEEDS_FILENAME, DB_SEEDS_CONTENT)

  rails_command "db:drop"

  # NOTE: as of 7/18/21 db:prepare behaves differently on SqlLite3 and PostgresSQL
  # explicitly running commands to avoid a seeding problem on SqlLite3
  rails_command "db:create"
  rails_command "db:migrate"
  rails_command "db:seed"
end

def generate_scaffolds
  generate :scaffold, "patient name"
  generate :scaffold, "doctor name"
  generate :scaffold, "appointment patient:references doctor:references scheduled:datetime"
end

def update_relations
  inject_into_class('app/models/patient.rb', 'Patient') { PATIENT_HAS_MANY_DOCTORS_ASSOCIATION }
  inject_into_class('app/models/doctor.rb', 'Doctor') { DOCTOR_HAS_MANY_PATIENTS_ASSOCATION }
end

generate_scaffolds
update_relations
initialize_db
