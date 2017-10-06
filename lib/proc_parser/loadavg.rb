module ProcParser
  class Loadavg
    #
    # This class read load average information from the /proc/loadavg file.
    #

    attr_accessor :loadavg1, :loadavg5, :loadavg15, :run_queue, :total_tasks, :last_pid
    @@attributes = {
      loadavg1:    0,
      loadavg5:    1,
      loadavg15:   2,
      run_queue:   3,
      total_tasks: 4,
      last_pid:    5,
    }

    def initialize(loadavg_file = '/proc/loadavg')
      raise NoProcData, "This system doesn't have /proc/loadavg data." if !File.exist?(loadavg_file)

      File.open(loadavg_file, 'r') do |file|
        firstline = file.readline.strip.squeeze(' ').sub('/', ' ').split(' ')
        raise NoProcData, 'Unknown format for /proc/loadavg' if firstline.count != 6

        @@attributes.each do |attribute, index|
          val = if index <= 2
                  firstline[index].to_f
                else
                  firstline[index].to_i
                end
          instance_variable_set("@#{attribute}", val)
        end
      end
    end
  end
end
