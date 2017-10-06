require 'spec_helper'

RSpec.describe ProcParser::Loadavg do
  describe '#initialize' do
    it 'should fail if the loadavg file does not exist' do
      expect { ProcParser::Loadavg.new('unknown-file') }.to raise_exception ProcParser::NoProcData
    end

    it 'should fail if the loadavg file is malformed' do
      expect do
        ProcParser::Loadavg.new('./spec/fixtures/broken_loadavg')
      end.to raise_exception ProcParser::NoProcData
    end

    context 'should parse correctly the data' do
      c = ProcParser::Loadavg.new('./spec/fixtures/loadavg')
      expected_values = {
        loadavg1: 2.35,
        loadavg5: 2.59,
        loadavg15: 2.58,
        run_queue: 3,
        total_tasks: 2_016,
        last_pid: 28_311,
      }
      expected_values.each do |attribute, val|
        it attribute.to_s do
          expect(c.send(attribute)).to eq val
        end
      end
    end
  end
end
