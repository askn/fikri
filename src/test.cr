require "./fikri/*"

module Fikri
  # Spec don't work on my current computer so I do here

  Task.all { |task|
    puts task.to_s
  }

  if task = Task.get "hello"
    task.active = true
    task.save
  end
end
