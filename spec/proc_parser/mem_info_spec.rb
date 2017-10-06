require 'spec_helper'

RSpec.describe ProcParser::MemInfo do
  describe '#initialize' do
    it 'should fail if the meminfo file does not exist' do
      expect { ProcParser::MemInfo.new('unknown-file') }.to raise_exception ProcParser::NoProcData
    end

    it 'should fail if the meminfo file has an unexpected unit' do
      expect { ProcParser::MemInfo.new('./spec/fixtures/broken_meminfo') }.to raise_exception ProcParser::NoProcData
    end

    context 'should parse correctly the data' do
      c = ProcParser::MemInfo.new('./spec/fixtures/meminfo')
      expected_values = {
        memtotal: 15990936,
        memfree: 766040,
        buffers: 12,
        cached: 3868012,
        swapcached: 298980,
        swaptotal: 16777212,
        swapfree: 8936328,
      }
      expected_values.each do |attribute, val|
        it attribute.to_s do
          expect(c.send attribute).to eq val
        end
      end
    end
  end

  describe '#memused' do
    it 'should compute the memory used' do
      c = ProcParser::MemInfo.new('./spec/fixtures/meminfo')
      expect(c.memused).to eq 15224896
    end
  end

  describe '#swapused' do
    it 'should compute the swap used' do
      c = ProcParser::MemInfo.new('./spec/fixtures/meminfo')
      expect(c.swapused).to eq 7840884
    end
  end

  describe '#free_buffers' do
    it 'should compute the memory really available (free + buffers and cached)' do
      c = ProcParser::MemInfo.new('./spec/fixtures/meminfo')
      expect(c.free_buffers).to eq 4634064
    end
  end
end
