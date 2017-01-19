require "./spec_helper"

describe Fikri do
  # TODO: Write tests

  it "should instancate a new Task" do
    task = Task.new "Test"
    task.active.should eq(false)
    task.should be_a(Task)
  end

  it "should save a new Task" do
    task = Task.new "Test"
    File.file?(TASKS_FILE).should eq(true)
    task.save.should eq(true)
  end
end
