require 'rugged'

module RelaxCI
  class RunScript
    attr_reader :logger

    def initialize(bus, logger)
      @bus = bus
      @logger = logger
    end

    def update(message)
      return unless message[:type] == "RepositoryCacheUpdated"

      logger.debug "Running script from #{message[:repository_path]}:#{message[:commit]}"
      repos = Rugged::Repository.new(message[:repository_path])
      commit = repos.lookup(message[:commit])
      bin_id = commit.tree.detect{|o| o[:name] == 'bin' }.fetch(:oid)
      bin = repos.lookup(bin_id)
      blob_id = bin.detect{|o| o[:name] == 'relax' }.fetch(:oid)
      relax_script = repos.lookup(blob_id).content
      file = Tempfile.new('relax-ci')
      begin
        file.write(relax_script)
        file.flush
      ensure
        file.close
        file.unlink
      end
    end
  end
end
