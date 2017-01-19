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
    Task.new("Test to save", true).save
    Task.count.should eq(old_count)
  end

  it "should update a task already saved" do
    Task.new("Task not done").save
    t = Task.get("Task not done").as(Task)
    t.active = true
    Task.get("Task not done").as(Task).active.should eq(true)
  end
end
