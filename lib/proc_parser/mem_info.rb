module ProcParser
  class MemInfo
    #
    # This class read memory information from the /proc/meminfo file.
    #
    # All the values returned by this class are in kilobytes.
    #

    # Contains the data in kilobytes
    attr_accessor :memtotal, :memfree, :buffers, :cached, :swapcached, :active, :inactive,
                  :active_anon, :inactive_anon, :active_file, :inactive_file, :unevictable,
                  :mlocked, :swaptotal, :swapfree, :dirty, :writeback, :anonpages, :mapped,
                  :slab, :sreclaimable, :sunreclaim, :pagetables, :nfs_unstable, :bounce,
                  :writebacktmp, :commitlimit, :committed_as, :vmalloctotal, :vmallocused,
                  :vmallochunk, :directmap4k, :directmap2m

    @@attributes = {
      memtotal: 'MemTotal',
      memfree: 'MemFree',
      buffers: 'Buffers',
      cached: 'Cached',
      swapcached: 'SwapCached',
      active: 'Active',
      inactive: 'Inactive',
      active_anon: 'Active\(anon\)',
      inactive_anon: 'Inactive\(anon\)',
      active_file: 'Active\(file\)',
      inactive_file: 'Inactive\(file\)',
      unevictable: 'Unevictable',
      mlocked: 'Mlocked',
      swaptotal: 'SwapTotal',
      swapfree: 'SwapFree',
      dirty: 'Dirty',
      writeback: 'Writeback',
      anonpages: 'AnonPages',
      mapped: 'Mapped',
      slab: 'Slab',
      sreclaimable: 'SReclaimable',
      sunreclaim: 'SUnreclaim',
      pagetables: 'PageTables',
      nfs_unstable: 'NFS_Unstable',
      bounce: 'Bounce',
      writebacktmp: 'WritebackTmp',
      commitlimit: 'CommitLimit',
      committed_as: 'Committed_AS',
      vmalloctotal: 'VmallocTotal',
      vmallocused: 'VmallocUsed',
      vmallocchunk: 'VmallocChunk',
      directmap4k: 'DirectMap4k',
      directmap2m: 'DirectMap2M',
    }

    def initialize(meminfo_file = '/proc/meminfo')
      raise NoProcData, "This system doesn't have /proc/meminfo data." if !File.exist?(meminfo_file)

      File.open(meminfo_file, 'r') do |file|
        data = file.read
        @@attributes.each_key do |attribute|
          value, unit = regex_match(attribute, data)
          if unit != 'kB'
            raise NoProcData, 'Unsupported unit stored in meminfo.'
          end
          instance_variable_set("@#{attribute}", value.to_i)
        end
      end
    end

    # Memory currently in use.
    #
    # We substract the free amount of memory to the total.
    def memused
      @memtotal - @memfree
    end

    # Swap currently in use.
    #
    # We substract the free amount of swap to the total.
    def swapused
      @swaptotal - @swapfree
    end

    # Memory available in the system. It is not just the free memory.
    #
    # The available memory is actually what the `free` command line tool calls `-/+ buffers/cache`.
    # It uses information from /proc/meminfo: it sums the MemFree, the Buffers and the Cached.
    #
    # cf. `free` source code: https://github.com/mmalecki/procps/blob/fe4c4a7314f32907b9f558ad0d8b8d0ff1cc76be/free.c#L97
    # cf. man 5 proc
    #
    def free_buffers
      @memfree + @buffers + @cached
    end

    private

    def regex_match(attribute, line)
      regex = Regexp.new("#{@@attributes[attribute]}:[[:space:]]*([[:digit:]]*) ([[:alpha:]]*)")
      m = regex.match(line)
      return m[1], m[2] if line =~ regex
    end
  end
end
