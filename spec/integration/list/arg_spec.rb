RSpec.describe "`constrinator list --arg` command", type: :cli do
  it "executes `constrinator list help --arg` command successfully" do
    output = `constrinator list help --arg`
    expected_output = <<-OUT
Usage:
  constrinator --arg

Options:
  -h, [--help], [--no-help]  # Display usage information

Command description...
    OUT

    expect(output).to eq(expected_output)
  end
end
