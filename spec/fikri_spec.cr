require "./spec_helper"

describe Fikri do
  Spec.before_each {
    File.delete(TASKS_FILE) if File.file?(TASKS_FILE)
  }

  it "should instancate a new Task" do
    task = Task.new "Test"
    task.active.should eq(false)
    task.should be_a(Task)
  end

  it "should save a new Task" do
    task = Task.new "Saved test"
    task.save.should eq(true)
    File.file?(TASKS_FILE).should eq(true)
  end

  it "should find a task saved" do
    Task.new("Test to save").save

    t = Task.get("Test to save")
    t.should be_a(Task)
  end

  # Create a task with an existing name and save it.
  # This task should overwride old one and the count of
  # tasks should not change
  it "should not save a task already saved" do
    Task.new("Test to save").save
    old_count = Task.count
    Task.new("Test to save", true).save.should eq(true)
    Task.count.should eq(old_count)
  end

  it "should update a task already saved" do
    # create tasks and save it
    Task.new("Task done").save
    # Get the same task from database and toggle it
    task_toggled = Task.get("Task done").as(Task)
    task_toggled.active = true
    task_toggled.save.should eq(true)
    # Get it again from database and check if task has been save
    # with new status
    if task = Task.get("Task done")
      task.as(Task).active.should eq(true)
    else
      raise Exception.new("Task not found")
    end
  end

  it "should toggle a task" do
    # create tasks and save it
    Task.new("Task done").save
    # Get the same task from database and toggle it
    Task.get("Task done").as(Task).toggle.should eq(true)
    # Get it again from database and check if task has been save
    # with new status
    if task = Task.get("Task done")
      task.as(Task).active.should eq(true)
    else
      raise Exception.new("Task not found")
    end
  end

  it "should delete a task" do
    Task.new("Test to delete").save
    old_count = Task.count
    Task.get("Test to delete").as(Task).delete.should eq(true)
    Task.count.should eq(old_count - 1)
  end
end
