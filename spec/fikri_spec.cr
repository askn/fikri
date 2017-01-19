require "./spec_helper"

describe Fikri do
  # TODO: Write tests

  it "should instancate a new Task" do
    task = Task.new "Test"
    task.active.should eq(false)
    task.should be_a(Task)
  end
end
