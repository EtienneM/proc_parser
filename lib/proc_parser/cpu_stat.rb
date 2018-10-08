module ProcParser
  class CPUStat
    #
    # This class read CPU usage information from the /proc/stat file. The behavior for Kernel
    # version prior to 2.5.41 is undefined.
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

    def initialize(stat_file = '/proc/stat')
      raise NoProcData, "This system doesn't have /proc/stat data." if !File.exist?(stat_file)

      File.open(stat_file, 'r') do |file|
        firstline = file.readline.strip.squeeze(' ').split(' ')
        raise NoProcData, 'Unsupported format of /proc/stat' if firstline[0] != 'cpu'

        @@attributes.each do |attribute, index|
          instance_variable_set("@#{attribute}", firstline[index].to_i)
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
    # The next values (idletime, non_idletime and totaltime) are computed based on the following
    # information:
    #
    # - https://stackoverflow.com/a/23376195/1351436
    # - `htop` source code: https://github.com/hishamhm/htop/blob/e0209da88faf3b390d71ff174065abd407abfdfd/ProcessList.c#L947
    # - man 5 proc
    #
    # Computing the percentage usage is done with the following algorithm:
    # totald = Total - PrevTotal
    # idled = Idle - PrevIdle
    # CPU_Percentage = (totald - idled)/totald
    #
    # With the Prev* variables fetched earlier than the current values.
    def idletime
      return @idle + @iowait
    end

    def non_idletime
      # Guest time is already accounted in user time
      user = @user - @guest
      nice = @nice - @guest_nice

      systemalltime = @system + @irq + @softirq
      virtalltime = @guest + @guest_nice
      return user + nice + systemalltime + @steal + virtalltime
    end

    def totaltime
      return idletime + non_idletime
    end
  end
end
