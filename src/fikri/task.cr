require "yaml"
require "colorize"

class Task
  YAML.mapping({
    task:   String,
    active: Bool,
  })

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
    puts MESSAGES["add"]
    File.open(TASKS_FILE, "a") do |f|
      f << "- task: #{task}\n  active: false\n"
    end
    puts "\n\t#{state(false)} #{task}\n\n"
  end

  def self.delete(id)
    puts MESSAGES["delete"]
    tasks = tasks
    t = tasks[id]
    tasks.delete tasks[id]
    puts "\n\t#{state(t.active)} #{t.task}\n\n"
    write_tasks(tasks)
  end

  def self.toggle(id)
    tasks = tasks
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

  private def self.tasks
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
