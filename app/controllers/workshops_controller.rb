# app/controllers/workshops_controller.rb
class WorkshopsController < ApplicationController
  # The index method is used to display 
  # the workshops that a user can sign up for.
  # The @selected array holds the workshop ids
  # that the logged-in user has already selected.
  def index
    id = cookies.signed[:id]
    previous = WorkerWorkshop.find_all_by_worker_id(id)
    @selected = Array.new
    previous.each do |w|
      @selected.push w.workshop_id
    end
    @workshops = Workshop.all
  end
  
  # The insert method is used to insert records
  # into the worker_workshop table.  The
  # update_worker_workshops function is a 
  # plpgsql function that deletes the old
  # records in that table for the given worker
  # id.
  # The insert method takes the array of 
  # workshop ids that the user has selected
  # and converts this into a single string
  # that is comma-delimited
  def insert
    values = params[:workshop_ids]
    conn = ActiveRecord::Base.connection
    id = cookies.signed[:id]
    workshop_list = ""
    count = 0
    values.each do |v|
      workshop_list += v.to_s
      if count < values.size - 1
        workshop_list += ","
      end
      count += 1
    end
      
    conn.execute("select update_worker_workshops(" + 
      id.to_s + ",'" + workshop_list+ "')")
    redirect_to :action=>"success", :controller=>"workshops"
  end
  
  
  def select_workshop
    @workshops = Workshop.all
  end
  def department
    @departments = ["deptA","deptB","deptC"]
  end
  def deptsummary
    department = params[:department]
    dept = WorkerWorkshops.find_all_by_department(department)
    workshops = Workshop.all
    @counts = Array.new
    workshops.each do |w|
      @counts << {:id => w.id,:num => 0,:title => w.title}
    end
    dept.each do |d|
      @counts.each do |c|
        if d.wsid == c[:id]
          c[:num] = c[:num] + 1
        end
      end
    end
    textVersion = ""
    @counts.each do |c|
      textVersion += c[:title] + " " + c[:num].to_s + "\n"
    end
    respond_to do |format|
      format.html { render :html => @counts }
      format.json { render :json => @counts }
      format.any { render :xml => textVersion }
    end
  end
  
  def show_participants
    id = params[:workshop_id]
    @participants = WorkerWorkshops.find_all_by_wsid(id)
    wkshop = Workshop.find_by_id(id)
    @title = wkshop[:title]
    if @participants.count == 0
      @participants = Array.new
      @participants << { :name => "None" }
    end
  end
  
  def summary
    workshops = Workshop.all
    @values = Array.new
    workshops.each do |w|
      wkscount = WorkerWorkshops.find_all_by_wsid(w.id).count
      @values << { :title => w.title, :count => wkscount }
    end
  end
end
