RSpec.describe "`constrinator list` command", type: :cli do
  it "executes `constrinator help list` command successfully" do
    output = `constrinator help list`
    expected_output = <<-OUT
Usage:
  constrinator list

Options:
  -h, [--help], [--no-help]  # Display usage information

Command description...
    OUT

    expect(output).to eq(expected_output)
  end
end
