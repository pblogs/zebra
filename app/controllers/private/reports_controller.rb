class Private::ReportsController < ApplicationController

  layout "private"
  before_filter :load_user, :only => [:user_time]
  before_filter :load_crew, :only => [:crew_time]
  before_filter :kickout, :only => :user_time
  require 'fastercsv'

  filter_access_to :all

  def user_time
    @page_title = "User Time"
    session[:report] = "user_time"
    if session[:offset].blank? : session[:offset] = Time.now end
    @date = session[:offset]
    generate_front_to_back
    @entries = TimeEntry.find(:all,
      :conditions => { :clock_in => @back.to_date...@front.to_date, :user_id => params[:id] },
      :include => { :time_sheet => :estimates},
      :order => "clock_in ASC")
  end

  def crew_time
    session[:report] = "crew_time"
    if session[:offset].blank? : session[:offset] = Time.now end
    @date = session[:offset]
    generate_front_to_back
    @users = @crew.users
  end

  def time_entries
    @page_title = "Recent Time Entries"
    session[:report] = "time_entries"
    if session[:offset].blank? : session[:offset] = Time.now end
    @date = session[:offset]
    generate_front_to_back

    @entries = TimeEntry.find(:all,
      :conditions => { :clock_in => @back.to_date...@front.to_date },
      :order => "clock_in ASC",
      :include => [:user, {:time_sheet => :estimates}])
  end

  def increase_offset
     session[:offset] += 1.months
     redirect_to :action => session[:report], :id => params[:id]
  end

  def decrease_offset
    session[:offset] -= 1.months
    redirect_to :action => session[:report], :id => params[:id]
  end

  def reset_offset
    session[:offset] = Time.now
    redirect_to :action => session[:report], :id => params[:id]
  end

  def accountant_csv
    if session[:offset].blank? : session[:offset] = Time.now end
    @date = session[:offset]
    generate_front_to_back

    csv_string = FasterCSV.generate do |csv|
      csv << ["Name", "Rate", "Straight Time", "Over Time", "Per Diem", "Bank or Pay",
              "Less Advance", "Less 50% Benefits", "Direct Deposit", "SIN", "Start Date", "Notes"]
      @users = User.all
      @users.each do |u|
        @entries = TimeEntry.find(:all,
                                  :conditions => { :clock_in => @back.to_date...@front.to_date, :user_id => u.id },
                                  :order => "clock_in ASC",
                                  :include => [:time_sheet])
        if @entries
          straight_time = sprintf("%.2f", @entries.sum(&:straight_time))
          over_time     = sprintf("%.2f", @entries.sum(&:over_time))
          per_diem      = sprintf("%.2f", @entries.sum(&:per_diem_cost))
          u.bank_overtime_hours ? bank = "Bank" : bank = "Pay Out"
          csv << [u.name, u.rate, straight_time, over_time, per_diem, bank]
        else
          csv << [u.name, u.rate]
        end
      end
    end
    send_data(csv_string,
       :type => 'text/csv; charset=utf-8; header=present',
       :filename => "Payroll_#{@back}_to_#{@front}.csv")
  end

  def user_time_csv
    if session[:offset].blank? : session[:offset] = Time.now end
    @date = session[:offset]
    generate_front_to_back

    csv_string = FasterCSV.generate do |csv|
      if permitted_to? :manage, :private_time_entries
      csv << ["Name", "Rate", "Straight Time", "Over Time", "Per Diem",
              "Reported Clock In", "Reported Clock Out", "Actual Clock In", "Actual Clock Out"]
      else
        csv << ["Name", "Rate", "Straight Time", "Over Time", "Per Diem",
                "Clock In", "Clock Out"]
      end
      @user = User.find(params[:id])
      @entries = TimeEntry.find(:all, :conditions => { :clock_in => @back.to_date...@front.to_date, :user_id => @user.id },
                                :order => "clock_in ASC",
                                :include => [:time_sheet, :user])
      if @entries
        @entries.each do |e|
          clock_in = e.clock_in.strftime('%Y-%m-%d %I:%M %p') if e.clock_in
          clock_out = e.clock_out.strftime('%Y-%m-%d %I:%M %p') if e.clock_out
          clocked_in_at = e.clocked_in_at.strftime('%Y-%m-%d %I:%M %p') if e.clocked_in_at
          clocked_out_at = e.clocked_out_at.strftime('%Y-%m-%d %I:%M %p') if e.clocked_out_at
          if permitted_to? :manage, :private_time_entries
          csv << [e.user.name, e.user.rate, e.straight_time, e.over_time, e.per_diem,
                  clock_in, clock_out, clocked_in_at, clocked_out_at]
          else
            csv << [e.user.name, e.user.rate, e.straight_time, e.over_time, e.per_diem,
                    clock_in, clock_out]
          end
        end
      end

    end
    send_data(csv_string,
       :type => 'text/csv; charset=utf-8; header=present',
       :filename => "#{@user.first_name}-#{@user.last_name}_#{@back}_to_#{@front}.csv")
  end

private

  def generate_front_to_back
    if @date.day <= 23
      @back  = @date.year.to_s + "-" + (@date - 1.month).month.to_s + "-" + "24"
      @front = @date.year.to_s + "-" + @date.month.to_s + "-" + "24"
    else
      @back = @date.year.to_s + "-" + @date.month.to_s + "-" + "24"
      @front  = @date.year.to_s + "-" + (@date + 1.month).month.to_s + "-" + "24"
    end
  end

  def load_user
    @user = User.find(params[:id])
  end

  def load_crew
    @crew = Crew.find(params[:id])
    roles = Role.find(:all, :conditions => { :id => current_user.versioned_role_ids.split(", ") })
    if roles.include?(Role.find(:first, :conditions =>{ :name => "office"})) or roles.include?(Role.find(:first, :conditions =>{ :name => "admin"}))
    else
      if ! @crew.id.eql?(current_user.crew_id)
        flash[:notice] = "You do not have permission to view the hours for this crew"
        redirect_to private_home_path
      end
    end
  end

  def kickout
    unless params[:id] == current_user.id.to_s || current_user.role_symbols.include?(:admin) || current_user.role_symbols.include?(:office) || current_user.role_symbols.include?(:foreman)
      redirect_to private_home_path
    end
  end

end