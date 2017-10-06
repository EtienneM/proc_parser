require 'spec_helper'

RSpec.describe ProcParser::CPUStat do
  describe '#initialize' do
    it 'should fail if the stat file does not exist' do
      expect { ProcParser::CPUStat.new('unknown-file') }.to raise_exception ProcParser::NoProcData
    end

    it 'should fail if the stat file has an unexpected format' do
      expect { ProcParser::CPUStat.new('./spec/fixtures/broken_cpu_stat') }.to raise_exception ProcParser::NoProcData
    end

    context 'should parse correctly the data' do
      c = ProcParser::CPUStat.new('./spec/fixtures/cpu_stat')
      expected_values = {
        nb_cpu: 4,
        user: 26845024,
        nice: 1141034,
        system: 3698335,
        idle: 21944941,
        iowait: 43319,
        irq: 1,
        softirq: 241181,
        steal: 2,
        guest: 3,
        guest_nice: 5,
      }
      expected_values.each do |attribute, val|
        it attribute.to_s do
          expect(c.send attribute).to eq val
        end
      end
    end
  end

  describe '#percentage_usage' do
    it 'should compute the percentage usage' do
      c = ProcParser::CPUStat.new('./spec/fixtures/cpu_stat')
      expect(c.percentage_usage).to eq 0.14803981118984352
    end
  end
end
