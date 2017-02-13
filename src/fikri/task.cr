require "yaml"
require "colorize"

class Task
  YAML.mapping({
    name:   String,
    active: Bool,
  })

  def self.create_database
    File.new(TASKS_FILE, "a") unless File.file?(TASKS_FILE)
  end

  def initialize(@name : String = "No name", @active : Bool = false)
  end

  def initialize(name : YAML::Any, active : YAML::Any)
    @name = name.as_s
    @active = active.as_s == "true" ? true : false
  end

  def self.all : Array(Task)
    Task.create_database
    tasks = [] of Task
    data = YAML.parse(File.read(TASKS_FILE))
    if data.raw
      data.each do |any_task|
        if any_task["name"]? && any_task["active"]?
          tasks.push Task.new(any_task["name"], any_task["active"])
        end
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
    File.open(TASKS_FILE, "a") do |f|
      f << "\n- name: #{@name}\n  active: #{@active}\n"
      return true
    end
    return false
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

    File.open(TASKS_FILE, "w") do |file|
      YAML.dump(new_data, file)
      return true
    end
    return false
  end

  def to_s : String
    state = @active ? "✓".colorize(:green) : "✕".colorize(:red)
    return "%s | %s" % [state, @name]
  end

  def to_h : Hash
    return {"name" => @name, "active" => @active}
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
    # writte the file with the new array produced
    File.open(TASKS_FILE, "w") do |file|
      YAML.dump(new_data, file)
      return true
    end
    return false
  end

  # Change the status and save
  def toggle : Bool
    @active = !@active
    self.save
  end

  private def self.state(state : Bool)
    state ? "✓".colorize(:green) : "✕".colorize(:red)
  end
end
