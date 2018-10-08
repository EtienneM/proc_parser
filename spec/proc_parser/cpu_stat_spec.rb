require 'spec_helper'

RSpec.describe ProcParser::CPUStat do
  describe '#initialize' do
    it 'should fail if the stat file does not exist' do
      expect { ProcParser::CPUStat.new('unknown-file') }.to raise_exception ProcParser::NoProcData
    end

    it 'should fail if the stat file has an unexpected format' do
      expect do
        ProcParser::CPUStat.new('./spec/fixtures/broken_cpu_stat')
      end.to raise_exception ProcParser::NoProcData
    end

    context 'should parse correctly the data' do
      c = ProcParser::CPUStat.new('./spec/fixtures/cpu_stat')
      expected_values = {
        nb_cpu: 4,
        user: 26_845_024,
        nice: 1_141_034,
        system: 3_698_335,
        idle: 21_944_941,
        iowait: 43_319,
        irq: 1,
        softirq: 241_181,
        steal: 2,
        guest: 3,
        guest_nice: 5,
      }
      expected_values.each do |attribute, val|
        it attribute.to_s do
          expect(c.send(attribute)).to eq val
        end
      end
    end
  end

  describe '#idletime' do
    it 'should compute the percentage usage' do
      c = ProcParser::CPUStat.new('./spec/fixtures/cpu_stat')
      expect(c.idletime).to eq 21_988_260
    end
  end

  describe '#non_idletime' do
    it 'should compute the percentage usage' do
      c = ProcParser::CPUStat.new('./spec/fixtures/cpu_stat')
      expect(c.non_idletime).to eq 31_925_577
    end
  end

  describe '#totaltime' do
    it 'should compute the percentage usage' do
      c = ProcParser::CPUStat.new('./spec/fixtures/cpu_stat')
      expect(c.totaltime).to eq 53_913_837
    end
  end
end
