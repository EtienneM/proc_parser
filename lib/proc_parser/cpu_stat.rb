module ProcParser
  class CPUStat
    #
    # This class read CPU usage information from the /proc/stat file. The behavior for Kernel version
    # prior to 2.5.41 is undefined.
    #

    attr_accessor :user, :nice, :system, :idle, :iowait, :irq, :softirq, :steal, :guest, :guest_nice
    @@attributes = {
      user:       1,
      nice:       2,
      system:     3,
      idle:       4,
      iowait:     5,
      irq:        6,
      softirq:    7,
      steal:      8,
      guest:      9,
      guest_nice: 10,
    }

    attr_accessor :nb_cpu


    def initialize(stat_file='/proc/stat')
      raise NoProcData, "This system doesn't have /proc/stat data." if not File.exists?(stat_file)

      File.open(stat_file, 'r') do |file|
        firstline = file.readline.strip.squeeze(' ').split(' ')
        raise NoProcData, 'Unsupported format of /proc/stat' if firstline[0] != 'cpu'

        @@attributes.each do |attribute, index|
          instance_variable_set("@#{attribute.to_s}", firstline[index].to_i)
        end

        @nb_cpu = 0
        file.each do |line|
          splitted_line = line.strip.squeeze(' ').split(' ')
          break if !splitted_line[0].start_with? 'cpu'
          @nb_cpu += 1
        end
      end
    end

    #
    ## Get the current CPU usage in percentage. It's a global percentage normalized on the number of
    # CPU.
    #
    # The CPU usage is actually everything but the idle time of the CPU.
    #
    # cf. `htop` source code: https://github.com/hishamhm/htop/blob/e0209da88faf3b390d71ff174065abd407abfdfd/ProcessList.c#L947
    # cf. man 5 proc
    # cf. https://stackoverflow.com/a/23376195/1351436
    #
    def percentage_usage
      # Guest time is already accounted in user time
      user = @user - @guest
      nice = @nice - @guest_nice

      idlealltime = @idle + @iowait
      systemalltime = @system + @irq + @softirq
      virtalltime = @guest + @guest_nice
      non_idlealltime = user + nice + systemalltime + @steal + virtalltime

      total = idlealltime + non_idlealltime
      return non_idlealltime / total.to_f / @nb_cpu
    end
  end
end
