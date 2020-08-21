require 'constrinator/commands/list///arg'

RSpec.describe Constrinator::Commands::List::::Arg do
  it "executes `list --arg` command successfully" do
    output = StringIO.new
    options = {}
    command = Constrinator::Commands::List::::Arg.new(options)

    command.execute(output: output)

    expect(output.string).to eq("OK\n")
  end
end
