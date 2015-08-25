namespace :seed_fake_data do
  def random_skill
    Skill.offset(rand(Skill.count)).first
  end

  def seed_skills(n)
    n.round.times do
      Skill.create! title: "#{Faker::Hacker.adjective} #{Faker::Hacker.abbreviation} #{Faker::App.version}".titleize

      print "s"
    end
  end

  def seed_jobs(n)
    n.round.times do
      Job.create! do |j|
        j.title = Faker::Name.title
        j.created_at = Faker::Time.between(1.month.ago, Time.now)
        j.expires_in_days = 5 + rand(30)
        j.salary = 100 + rand(10000)
        j.contacts = "#{Faker::PhoneNumber.cell_phone}, #{Faker::Internet.email}"

        j.skills = (0..(5 + rand(10))).to_a.map { random_skill }
      end

      print "j"
    end
  end

  def seed_employee(n)
    n.round.times do
      Employee.create! do |em|
        em.name = "#{Faker::Name.first_name.to_cyr} #{Faker::Name.first_name.to_cyr} #{Faker::Name.last_name.to_cyr}".gsub(/[^а-я ]+/im, "").titleize
        em.salary = 100 + rand(10000)
        em.phone = Faker::PhoneNumber.cell_phone
        em.email = Faker::Internet.email
        em.status = [Employee::STATUS_NEED_JOB, Employee::STATUS_GOT_JOB].sample

        em.skills = (0..(5 + rand(10))).to_a.map { random_skill }
      end

      print "e"
    end
  end

  desc "50 jobs, 150 employees"
  task :small => :environment do
    k = 1.0

    seed_skills(k * 50)
    seed_jobs(k * 50)
    seed_employee(k * 150)
  end
end
