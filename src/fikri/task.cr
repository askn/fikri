require "yaml"
require "colorize"

class Task
  YAML.mapping({
    id:     Int32,
    name:   String,
    active: Bool,
  })

  def self.create_database
    File.new(TASKS_FILE, "a") unless File.file?(TASKS_FILE)
  end

  def initialize(@name : String = "No name", @active : Bool = false)
    @id = 0
  end

  def initialize(data : YAML::Any)
    @name = data["name"]? ? data["name"].as_s : "No name"
    @active = data["active"]? && data["active"].as_s == "true" ? true : false
    @id = data["id"]? ? data["id"].as_s.to_i32 : -1
  end

  def self.all : Array(Task)
    Task.create_database
    tasks = [] of Task
    data = YAML.parse(File.read(TASKS_FILE))
    if data.raw
      data.each do |any_task|
        tasks.push Task.new(any_task)
      end
    end
    return tasks
  end

  def self.count : Int32
    count = Int32.new 0
    tasks = Task.all
    if tasks != Nil
      tasks.each { count += 1 }
    end
    return count
  end

  def self.get(name : String) : Task
    tasks = Task.all
    Task.all.each { |task|
      return task if (task.name == name)
    }
    raise Exception.new "Task not found"
  end

  def self.exists?(name : String) : Bool
    begin
      Task.get name
      return true
    rescue Exception
      return false
    end
  end

  def save : Bool
    Task.create_database
    # if task already exist, we update it
    # else we create the task
    if Task.exists? @name
      self.update
    else
      self.insert
    end
  end

  def insert : Bool
    tasks = [] of Task

    Task.all.each do |task|
      @id = task.id + 1
      tasks << task
    end
    tasks << self
    new_data = tasks.map { |task| task.to_h }
    return write_data(new_data)
  end

  def update : Bool
    # Open file and construct a new array
    new_data = YAML.parse(File.read(TASKS_FILE)).map do |any_task|
      if any_task["name"] == @name
        {"name" => @name, "active" => @active}
      else
        any_task
      end
    end

    return write_data(new_data)
  end

  def to_s : String
    state = @active ? "✓".colorize(:green) : "✕".colorize(:red)
    return "%s | %s" % [state, @name]
  end

  def to_h : Hash
    return {"id" => @id, "name" => @name, "active" => @active}
  end

  def self.init
    if File.file? TASKS_FILE
      File.delete TASKS_FILE
      msg = "Reinitialized #{TASKS_FILE}"
    else
      msg = "Initialized #{TASKS_FILE}"
    end
    File.new TASKS_FILE, "w"
  end

  def delete : Bool
    # Open file and construct a new array
    new_data = YAML.parse(File.read(TASKS_FILE)).reject { |any_task| any_task["name"] == @name }
    return write_data(new_data)
  end

  # Change the status and save
  def toggle : Bool
    @active = !@active
    self.save
  end

  private def self.state(state : Bool)
    state ? "✓".colorize(:green) : "✕".colorize(:red)
  end

  # write the given data into the yaml file
  private def write_data(data) : Bool
    File.open(TASKS_FILE, "w") do |file|
      YAML.dump(data, file)
      return true
    end
    return false
  end
end
