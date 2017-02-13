require "./fikri/*"
require "option_parser"

module Fikri
  old_argv = ARGV.dup

  at_exit do
    opts = OptionParser.new do |parser|
      parser.banner = "Usage: fikri [arguments]"
      parser.on("-a \"name\"", "--add=\"name\"", "add a new task") do |name|
        task = Task.new name
        task.save
        puts MESSAGES["add"]
      end
      parser.on("-t name", "--toggle=name", "change status") do |name|
        if task = Task.get(name)
          task.as(Task).toggle
          puts MESSAGES["complete"]
        else
          puts MESSAGES["404"]
        end
      end
      parser.on("-d name", "--delete=name", "delete task") do |name|
        if task = Task.get(name)
          task.as(Task).delete
          puts MESSAGES["delete"]
        else
          puts task.class
          puts MESSAGES["404"]
        end
      end
      parser.on("-l", "--list", "list all tasks") {
        Task.all.each { |task| puts task.to_s }
      }
      parser.on("-h", "--help", "Show this help") { puts parser }
    end

    opts.parse!
  end
end
