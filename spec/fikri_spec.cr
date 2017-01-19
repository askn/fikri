require "./spec_helper"

describe Fikri do
  # TODO: Write tests

  it "should instancate a new Task" do
    task = Task.new "Test"
    task.active.should eq(false)
    task.should be_a(Task)
  end

  it "should save a new Task" do
    task = Task.new "Saved test"
    File.file?(TASKS_FILE).should eq(true)
    task.save.should eq(true)
  end

  it "should find a test saved" do
    Task.new("Test to save").save

    t = Task.get("Test to save")
    t.should be_a(Task)
  end
end
