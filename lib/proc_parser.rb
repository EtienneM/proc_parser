require 'proc_parser/version'

module ProcParser
  class NoProcData < RuntimeError; end
end

require 'proc_parser/cpu_stat'
require 'proc_parser/loadavg'
require 'proc_parser/mem_info'
