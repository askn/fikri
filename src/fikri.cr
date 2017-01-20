require "./fikri/*"
require "option_parser"

module Fikri
  old_argv = ARGV.dup

  at_exit do
    opts = OptionParser.new do |parser|
      parser.banner = "Usage: fikri [arguments]"
      parser.on("-a \"task\"", "--add=\"task\"", "add a new task") do |task|
        Task.add(task)
      end
      parser.on("-t name", "--toggle=name", "change status") do |name|
        if task = Task.get(name)
          task.as(Task).toggle
        else
          puts "Task was not found"
        end
      end
      parser.on("-d name", "--delete=name", "delete task") do |name|
        if task = Task.get(name)
          task.as(Task).delete
        else
          puts "Task was not found"
        end
      end
      parser.on("-l", "--list", "list all tasks") { Task.list }
      parser.on("-h", "--help", "Show this help") { puts parser }
      parser.on("init", "initialize") { Task.init }
    end

    if old_argv[0]? && old_argv[0] == "init"
      Task.init
    else
      if old_argv.size > 0
        if File.file?(TASKS_FILE)
          opts.parse!
        else
          puts MESSAGES["init"]
        end
      else
        if File.file?(TASKS_FILE)
          opts.parse(["-l"])
        else
          puts MESSAGES["init"]
        end
      end
    end
  end
end
