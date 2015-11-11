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
      parser.on("-t id", "--toggle=id", "change status") do |id|
        Task.toggle(id.to_i)
      end
      parser.on("-d id", "--delete=id", "delete task") do |id|
        Task.delete(id.to_i)
      end
      parser.on("-l", "--list", "list all tasks") { Task.list }
      parser.on("-h", "--help", "Show this help") { puts parser }
      parser.on("init", "initialize") { Task.init }
    end

    if old_argv[0] == "init"
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
