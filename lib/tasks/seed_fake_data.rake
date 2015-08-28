namespace :seed_fake_data do
  def random_skill
    Skill.offset(rand(Skill.count)).first
  end

  def seed_skills(n)
    n.round.times do
      Skill.create title: "#{Faker::Hacker.adjective} #{Faker::Hacker.abbreviation} #{Faker::App.version}".titleize

      print "s"
    end
  end

  def seed_jobs(n)
    n.round.times do
      Job.create! do |j|
        j.title = Faker::Name.title
        j.created_at = Faker::Time.between(7.days.ago, Time.now)
        j.expires_in_days = 5 + rand(10)
        j.salary = 100 + rand(10000)
        j.contacts = "#{Faker::PhoneNumber.cell_phone}, #{Faker::Internet.email}"

        j.skills = (0..(1 + rand(4))).to_a.map { random_skill }
      end

      print "j"
    end
  end

  def seed_employee(n)
    n.round.times do
      Employee.create! do |em|
        em.name = "#{Faker::Name.first_name.to_cyr} #{Faker::Name.first_name.to_cyr} #{Faker::Name.last_name.to_cyr}".gsub(/[^а-я ]+/im, "").titleize
        em.salary = 100 + rand(12000)
        em.phone = Faker::PhoneNumber.cell_phone
        em.email = Faker::Internet.email
        em.status = [Employee::STATUS_NEED_JOB, Employee::STATUS_GOT_JOB].sample

        em.skills = (0..(1 + rand(15))).to_a.map { random_skill }
      end

      print "e"
    end
  end

  def seed_data
    seed_skills(5)
    seed_jobs(50)
    seed_employee(150)
  end

  task :small => :environment do
    seed_data
  end

  task :medium => :environment do
    10.times { seed_data }
  end

  task :large => :environment do
    100.times { seed_data }
  end

  task :unlimited => :environment do
    while true
      seed_data
      print "#{Employee.count}|#{Job.count}|#{Skill.count}"

      exit if Employee.count > 1000_000
    end
  end
end
