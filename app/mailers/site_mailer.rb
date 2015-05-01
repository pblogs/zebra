class SiteMailer < ActionMailer::Base
  default :from => "notify@aaastriping.ca"

  def password_reset_instructions(user)
    @edit_password_reset_url = edit_password_reset_url(user.perishable_token)
    @user = user
    mail(:to => user.email, :subject => "[AAAS] Password Reset")
  end

  def new_time_sheet(time_sheet)
    @time_sheet = time_sheet
    mail(:to => "dorian@aaastriping.ca", :subject => "[AAAS] New Time Sheet (##{time_sheet.id})")
  end

  def new_load_sheet(load_sheet)
    @load_sheet = load_sheet
    mail(:to => "dorian@aaastriping.ca", :subject => "[AAAS] New Load Sheet (##{load_sheet.id})")
  end

  def new_gun_sheet(gun_sheet)
    @gun_sheet = gun_sheet
    mail(:to => "dorian@aaastriping.ca", :subject => "[AAAS] New Gun Sheet (##{gun_sheet.id}) for #{gun_sheet.job.label}")
  end

  def new_contact(contact)
    @contact = contact
    mail(:to => "info@aaastriping.ca", :subject => "[AAAS] New Contact - #{contact.name}")
  end

  def new_career(career)
    @career = career
    mail(:to => "info@aaastriping.ca", :subject => "[AAAS] New Employment - #{career.name}")
  end

  def time_sheet_over_hours(time_sheet,hours,user)
    @time_sheet = time_sheet
    @hours = hours
    @user = user

    mail(:to => "info@aaastriping.ca", :subject =>  "[AAAS] #{hours} Hours Worked In One Shift")
 end

  def time_sheet_many_hours(time_sheet,hours,user)
    @time_sheet = time_sheet
    @hours = hours
    @user = user

    mail(:to => "info@aaastriping.ca", :subject =>  "[AAAS] #{hours} Total Worked In One Pay Period")
  end

  def job_marking_production_over_expected(marking)
    @marking = marking

    mail(:to => "dorian@aaastriping.ca", :subject =>  "[AAAS] #{marking.gun_marking_category.try(:name)} Production higher than Expected")
  end

  def equipment_alert(equipment, flag)
    @equipment = equipment
    @flag = flag

    mail(:to => "info@aaastriping.ca", :subject =>  "[AAAS] Equipment alert")
  end

  def send_reminder_notice(job)
    @job = job
    mail(to: job.reminder_email, subject: "[AAAS] Reminder Notice")
  end

  def send_job_estimate_notice(job_estimate, email)
    @job_estimate = job_estimate
    mail(to: email, subject: "[AAAS] Job Estimate notice")
  end
end
