# This is an autogenerated function, ported from the original legacy version.
# It /should work/ as is, but will not have all the benefits of the modern
# function API. You should see the function docs to learn how to add function
# signatures for type safety and to document this function using puppet-strings.
#
# https://puppet.com/docs/puppet/latest/custom_functions_ruby.html
#
# ---- original file header ----
require 'fileutils'
require 'yaml'
require 'etc'

# Retrieves data from a cache file, or creates it with supplied data if the file doesn't exist
#
# Useful for having data that's randomly generated once on the master side (e.g. a password), but
# then stays the same on subsequent runs.
#
# Usage: cache_data(name, initial_data)
# Example: $password = cache_data("mysql_password", random_password(32))
# ---- original file header ----
#
# @summary
#   Summarise what the function does here
#
Puppet::Functions.create_function(:'foreman::cache_data') do
  # @param args
  #   The original array of arguments. Port this to individually managed params
  #   to get the full benefit of the modern function API.
  #
  # @return [Data type]
  #   Describe what the function returns here
  #
  dispatch :default_impl do
    # Call the method named 'default_impl' when this is matched
    # Port this to match individual params for better type safety
    repeated_param 'Any', :args
  end


  def default_impl(*args)
    
    raise Puppet::ParseError, 'Usage: cache_data(name, initial_data)' unless args.size == 2

    name = args[0]
    raise Puppet::ParseError, 'Must provide data name' unless name
    initial_data = args[1]

    cache_dir = File.join(Puppet[:vardir], 'foreman_cache_data')
    cache = File.join(cache_dir, name)
    if File.exists? cache
      YAML.load(File.read(cache))
    else
      FileUtils.mkdir_p cache_dir unless File.exists? cache_dir
      File.open(cache, 'w', 0600) do |c|
        c.write(YAML.dump(initial_data))
      end
      # Chown to puppet to prevent later cache-read errors when this is run as root
      if Etc.getpwuid.name == 'root' && (uid = (Etc.getpwnam('puppet').uid rescue nil))
        File.chown(uid, nil, cache)
        File.chown(uid, nil, cache_dir)
      end
      initial_data
    end
  
  end
end