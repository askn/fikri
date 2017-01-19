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

  def self.all(&block)
    File.open(TASKS_FILE, "r") do |file|
      data = YAML.parse(file)
      if data != nil
        data.each { |task_data|
          yield Task.new task_data["name"], task_data["active"]
        }
      end
    end
  end

  def self.count : Int32
    count = Int32.new 0
    Task.all { count += 1 }
    return count
  end

  def self.get(name : String) : Task | Nil
    Task.all { |task|
      return task if (task.name == name)
    }
    return nil
  end

  def save
    Task.create_database
    # if task already exist, we update it
    # else we create the task
    if Task.get @name
      self.update
    else
      self.insert
    end
  end

  def insert
    File.open(TASKS_FILE, "a") do |f|
      f << "\n- name: #{@name}\n  active: #{@active}\n"
      puts MESSAGES["add"]
      puts self.to_s
      return true
    end
    return false
  end

  def update
  end

  def to_s : String
    state = @active ? "✓".colorize(:green) : "✕".colorize(:red)
    return "%s | %s" % [state, @name]
  end

  def self.init
    if File.file? TASKS_FILE
      File.delete TASKS_FILE
      msg = "Reinitialized #{TASKS_FILE}"
    else
      msg = "Initialized #{TASKS_FILE}"
    end

    File.new TASKS_FILE, "w"
    puts msg
  end

  def self.add(task)
  end

  def self.delete(id)
    puts MESSAGES["delete"]
    tasks = get_tasks
    t = tasks[id]
    tasks.delete tasks[id]
    puts "\n\t#{state(t.active)} #{t.name}\n\n"
    write_tasks(tasks)
  end

  def self.toggle(id)
    tasks = get_tasks
    if tasks[id]?
      if tasks[id].active
        tasks[id].active = false
      else
        tasks[id].active = true
        puts MESSAGES["complete"]
      end
      write_tasks(tasks)

      t = tasks[id]
      puts "\n\t#{id} | #{state(t.active)} #{t.name}\n\n"
    else
      puts MESSAGES["dont_know"]
    end
  end

  def self.list
    Task.all { |task| puts task.to_s }
  end

  private def self.get_tasks
    doc = File.read(TASKS_FILE)
    if doc.empty?
      [] of Task
    else
      Array(Task).from_yaml(doc)
    end
  end

  private def self.write_tasks(tasks)
    File.open(TASKS_FILE, "w") do |f|
      Task.all { |t|
        f << "- task: #{t.name}\n  active: #{t.active}\n"
      }
    end
  end

  private def self.state(state : Bool)
    state ? "✓".colorize(:green) : "✕".colorize(:red)
  end
end
