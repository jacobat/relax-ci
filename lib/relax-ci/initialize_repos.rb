require 'fileutils'

module RelaxCI
  class InitializeRepos
    def initialize(bus, repos_collection_dir)
      @bus = bus
      @repos_collection_dir = repos_collection_dir
    end

    def update(message)
      return unless message[:type] == "PostCommitHookFired"
      unless @repos_collection_dir.exist?
        puts "Creating #{@repos_collection_dir}"
        FileUtils.mkdir_p(@repos_collection_dir)
      end

      repos_path = Pathname.new(URI.parse(message[:repos_url]).path.slice(1..-1))
      repos_collection = @repos_collection_dir.realpath
      new_repository = @repos_collection_dir.realpath.join(repos_path)

      unless subpath?(repos_collection, new_repository)
        raise "Trying to access path outside repository collection"
      end

      if new_repository.exist?
        puts "Fetching #{new_repository}"
        `git -C #{new_repository} fetch`
      else
        puts "Cloning #{new_repository}"
        `git clone --bare --depth=50 #{message[:repos_url]} #{new_repository}`
      end

      @bus.send_message(message.merge(type: "RepositoryCacheUpdated"))
    end

    def subpath?(parent_path, child_path)
      Regexp.new(/^#{parent_path}/).match(child_path.to_s)
    end
  end
end
