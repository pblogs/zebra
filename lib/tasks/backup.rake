require 'yaml'

# Heroku SQL to S3 Database backup task
#   by Derek Perez (March 15th, 2010), inspiration from Nick Merwin (Lemur Heavy Industries)
#   * takes raw postgresql dumps and uploads them to S3.
#
# Setup:
# 1) replace APP_NAME and BACKUP_BUCKET with your info
# 2) heroku config:add S3_KEY=YOURKEY S3_SECRET=YOURSECRET
# 3) add aws-s3 to your .gems
#
# Usage:
#    heroku rake backups:backup
#    * or add this to your cron.rake for hourly or nightly backups:
#    Rake::Task['backups:backup'].invoke

namespace :backups do

  desc "backup db from heroku and send to S3"
  task :backup => :environment do

    APP_NAME = 'aaa-striping' # put your app name here
    BACKUP_BUCKET = 'hnj-db-backups' # put your backup bucket name here
    DB_CONFIG = YAML::load(ERB.new(IO.read(File.join(RAILS_ROOT, 'config', 'database.yml'))).result)[RAILS_ENV]

    puts "backup started @ #{Time.now}"

    puts "dumping sql file.."

    backup_name =  "hnj_#{Time.now.to_s(:number)}.sql"
    backup_path = "tmp/#{backup_name}"

    `echo #{DB_CONFIG['password']} | pg_dump -Fc --username=#{DB_CONFIG['username']} --host=#{DB_CONFIG['host']} > #{backup_path}`

    puts "gzipping sql file..."
    `gzip #{backup_path}`

    backup_name += ".gz"
    backup_path = "tmp/#{backup_name}"

    puts "uploading #{backup_name} to S3..."
      AWS::S3::Base.establish_connection!(
        :access_key_id     => ENV['S3_KEY'],
        :secret_access_key => ENV['S3_SECRET']
      )

    begin
      bucket = AWS::S3::Bucket.find(BACKUP_BUCKET)
    rescue AWS::S3::NoSuchBucket
      AWS::S3::Bucket.create(BACKUP_BUCKET)
      bucket = AWS::S3::Bucket.find(BACKUP_BUCKET)
    end

    AWS::S3::S3Object.store(backup_name, File.read(backup_path), bucket.name, :content_type => 'application/x-gzip')
    `rm -rf #{backup_path}`
    puts "backup completed @ #{Time.now}"
  end

end