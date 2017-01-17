require "./fikri/*"

module Fikri
  # Spec don't work on my current computer so I do here

  Task.all.each { |task|
    puts task.to_s
  }

  task = Task.new "hello"
  task.save
end
