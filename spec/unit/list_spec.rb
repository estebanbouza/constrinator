require 'constrinator/commands/list'

RSpec.describe Constrinator::Commands::List do
  it "executes `list` command successfully" do
    output = StringIO.new
    options = {}
    command = Constrinator::Commands::List.new(options)

    command.execute(output: output)

    expect(output.string).to eq("OK\n")
  end
end
