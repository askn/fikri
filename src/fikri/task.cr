require "yaml"
require "colorize"

class Task
  YAML.mapping({
    name:   String,
    active: Bool,
  })

  def initialize(@name : String = "No name", @active : Bool = false)
  end

  def initialize(name : YAML::Any, active : YAML::Any)
    @name = name.as_s
    @active = active.as_s == "true" ? true : false
  end

  def self.all(&block)
    tasks = [] of Task
    File.open(TASKS_FILE, "r") do |file|
      tasks_data = YAML.parse file
      tasks_data.each { |task_data|
        yield Task.new task_data["name"], task_data["active"]
      }
      return tasks
    end
  end

  def self.get(name : String) : Task | Nil
    Task.all { |task|
      return task if task.name == name
    }
    return nil
  end

  def save
    # if task already exist, we update it
    # else we create the task
    if Task.get @name
      # update the task
    else
      puts MESSAGES["add"]
      File.open(TASKS_FILE, "a") do |f|
        f << "\n- name: #{@name}\n  active: #{@active}\n"
      end
      puts self.to_s
    end
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
    puts "\n\t#{state(t.active)} #{t.task}\n\n"
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
      puts "\n\t#{id} | #{state(t.active)} #{t.task}\n\n"
    else
      puts MESSAGES["dont_know"]
    end
  end

  def self.list
    tasks = get_tasks
    if tasks.size > 0
      puts MESSAGES["things"]
      tasks.each_with_index do |t, i|
        puts "\t#{i} | #{state(t.active)} #{t.task}"
      end
    else
      puts MESSAGES["wait"]
    end
    puts ""
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
      tasks.each do |t|
        f << "- task: #{t.task}\n  active: #{t.active}\n"
      end
    end
  end

  private def self.state(state : Bool)
    state ? "✓".colorize(:green) : "✕".colorize(:red)
  end
end
