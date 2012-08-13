require 'optparse'
require './lib/installed_softwares'
require './lib/helpers'
require 'win32ole'

def get_last_versions_infos()
  last_versions=Array.new
  puts "Get last softwares versions infos:"
  Dir.foreach(File.expand_path("./softwares_modules")) do | f |
    unless f == "." or f == ".."
      a_software = Hash.new
      require "./softwares_modules\/#{f}"
      a_software[:name] = f.gsub(/\.rb$/,"")
      a_software[:name].gsub!(/\_/," ")
      last_versions.push(a_software.clone)
    end
  end
  threads = Array.new
  last_versions.each do |s|
    puts "\t for #{s[:name]}"
    #Execute last_version method of each module:
    t = Thread.new {
      dyn_module = s[:name].capitalize.gsub(/\s/,"_") + ".last_version"
      s[:infos] = eval(dyn_module)
      }
    threads.push(t)
  end
  threads.each do | t |
    t.join
  end
  return last_versions
end
def get_installed_softwares_infos()
  puts "Get installed softwares infos"
  installed_versions  = InstalledSoftwares::names_and_version_list
  return installed_versions
end
def new_version?( installed_version, last_version)
  new_version = false
  first_v = installed_version.split(".")
  second_v = last_version.split(".")
  max_length = first_v.length <= second_v.length ? first_v.length : second_v.length
  for i in 0..( max_length -1)
    if first_v[i].to_i < second_v[i].to_i
      new_version = true
      break
    end
  end
  if max_length < second_v.length and new_version == false
    new_version = true
  end
  return new_version
end
def check_for_updates(last_versions, installed_versions)
  softwares_to_update=Array.new
  puts "check for updates:"
  last_versions.each do |s|
    if s[:infos][:err] == nil
      installed_versions.each do | inst_v |
        if inst_v[:DisplayName].downcase =~ /.*#{s[:name].downcase}.*/
          puts "->" + inst_v[:DisplayName]
          if new_version?(inst_v[:DisplayVersion], s[:infos][:version]) 
            puts "\t!!(up. avail.)!! inst. version : " + inst_v[:DisplayVersion] + " last version : " + s[:infos][:version]
          softwares_to_update.push(s)
          else
            puts "\tinst. version : " + inst_v[:DisplayVersion] + " last version : " + s[:infos][:version]
          end
          
        end
      end
    else
      puts s[:infos][:module_name] + "=>" + s[:infos][:err]
    end
  end
  return softwares_to_update
end
def display_non_installed()
  checked_softwares= Array.new()
  Dir.foreach(File.expand_path("./softwares_modules")) do | f |
    unless f == "." or f == ".."
      f.gsub!(/\.rb$/,"")
      f.gsub!(/\_/," ")
      checked_softwares.push(f)
    end
  end
  all_softs = InstalledSoftwares::names_list()
  checked_softwares.each do | sc |
    is_installed =false
    all_softs.each do | s |
      if s.downcase =~ /.*#{sc.downcase}.*/
        is_installed = true
      end
    end
    unless is_installed
      puts sc
    end
  end
end
def get_non_installed()
  checked_softwares= Array.new()
  non_installed = Array.new
  Dir.foreach(File.expand_path("./softwares_modules")) do | f |
    unless f == "." or f == ".."
      f.gsub!(/\.rb$/,"")
      f.gsub!(/\_/," ")
      checked_softwares.push(f)
    end
  end
  all_softs = InstalledSoftwares::names_list()
  checked_softwares.each do | sc |
    is_installed =false
    all_softs.each do | s |
      #puts "--sentinel -- #{s.downcase} =~ #{sc.downcase}"
      if s.downcase =~ /.*#{sc.downcase}.*/
        #puts "####################true"
        is_installed = true
      end
    end
    unless is_installed
      non_installed.push(sc.clone)
    end
  end
  return non_installed
end
def download_last_versions( dir, softwares_list)
  dir = dir || "."
  if File.directory?(File.expand_path(dir)) == false
    puts "#{File.expand_path(dir)} don't exist, create it."
    begin
      Dir.mkdir( dir)
      dir = File.expand_path(dir).gsub(/\\$/,"")
      dir += "\\" 
    rescue
      puts "Unable to create directory, downloaded files will be saved in default location"
      dir = ""
    end
  else
    dir =""  
  end

  require "./lib/donwloader"
  threads = Array.new
  softwares_list.each do | s |
    t = Thread.new {
      #puts s[:infos][:url]
      #puts dir
      #puts s[:infos][:filename]
      url_checked=Downloader::get(s[:infos][:url],dir + s[:infos][:filename] )
    }
    threads.push(t)
  end
  threads.each do | t |
    t.join
  end  
end

#manage parameters
options = {}
optparse = OptionParser.new do|opts|
  opts.banner='Usage:'
  opts.on( '-h', '--help', 'Display this screen ( see -qh parameters for query help)' ) do
    puts optparse
    exit
  end
  opts.on( '-q', '--query', 'switch to query mod:') do
    opts.on( '-l', '--managed-list', 'In query mod, display a list of the softwares that yougurt currently check') do
      Dir.foreach(File.expand_path("./softwares_modules")) do | f |
        unless f == "." or f == ".."
          f.gsub!(/\.rb$/,"")
          f.gsub!(/\_/," ")
          puts f
        end
      end
    end
    opts.on( '-L', '--installed-list', 'In query mod, display a list of all third party softwares installed') do  
      all_softs = InstalledSoftwares::names_list()
      i = 0
      all_softs.each do | name |
        puts (i+=1).to_s + "  " + name
      end
    end
    opts.on( '-v ', '--installed-version SOFTNAME_PATTERN', String, 'In query mod display the installed version if the software is installed') do | s |
      puts InstalledSoftwares::get_version_of(s)
    end
    opts.on( '-u', '--available-update', 'In query mod display all new versions available of already installed softwares') do 
      last_versions = get_last_versions_infos
      installed_versions = get_installed_softwares_infos
      check_for_updates(last_versions, installed_versions)
    end
    opts.on( '-i', '--non-installed', 'In query mod, display a list of all softwares that are not installed') do
      display_non_installed
    end
  end
  opts.on( '-d', '--download-updates [DIR]', 'Download all availables update in specified DIR (optionnal) or in default') do | d |
    directory = d || nil
    get_last_versions_infos
    get_installed_softwares_infos()
    software_to_update = check_for_updates()
    download_last_versions(directory, softwares_to_update)
  end
  opts.on( '-I', '--install [SOFT]', 'Install given software [SOFT] or all that are not installed (see -q --non-installed or -qi for a list)') do | s |
    software_manager = './lib/software_manager.rb'
    softwares_to_install = Array.new
    #if a software name pattern is given by user
    if s  
      #check non installed list with pattern
      non_installed = get_non_installed()
      non_installed.each do | soft_name |
        if soft_name.downcase =~ /.*#{s.downcase}.*/
          softwares_to_install.push({ :name => soft_name.clone})
        end
      end
    #else we install all softs that are not installed
    else
      non_installed = get_non_installed()
      non_installed.each do | soft_name |
        softwares_to_install.push({ :name => soft_name.clone})
      end
    end
    #if check is true
    if softwares_to_install.length > 0
      softwares_to_install.each do | name |
        f=name[:name].gsub(/\s/,"_")+".rb"
        require "./softwares_modules\/#{f}"
      end
      threads = Array.new
      puts "get infos :"
      softwares_to_install.each do |s|
        puts "\t for #{s[:name]}"
        t = Thread.new {
          dyn_module = s[:name].capitalize.gsub(/\s/,"_") + ".last_version"
          s[:infos] = eval(dyn_module)
          }
        threads.push(t)
      end
      threads.each do | t |
        t.join
      end
    else
      puts 'No match found (see -q --non-installed or -qi for a list of non installed softs)'
      exit 
    end
    puts "Download softwares"
    download_last_versions(nil, softwares_to_install)
    parameters=Array.new
    softwares_to_install.each do | soft |
      puts soft[:infos][:filename]
      parameters.push({:name=>File.expand_path(soft[:infos][:filename]),:param=>soft[:infos][:install_param]}) 
    end
    #puts parameters.inspect
    #parameters = [{:name=>"c:\\Users\\silkmoth\\Downloads\\Opera-Next-12.50-1513.i386.exe",:param=>"/silent"}]
    parameters_string = Helpers::create_software_manager_param_string(parameters)
    puts parameters_string
    shell = WIN32OLE.new('Shell.Application')
    shell.ShellExecute('ruby.exe', software_manager + " -I " + parameters_string, nil, 'runas')
  end
  opts.on( '-U', '--update', 'Update all already installed softwares if it exists a newer version') do 
    softwares_to_install = nil
    software_manager = './lib/software_manager.rb'
    last_versions = get_last_versions_infos
    installed_versions = get_installed_softwares_infos
    softwares_to_install = check_for_updates(last_versions, installed_versions)
    
    puts "Download softwares"
    download_last_versions(nil, softwares_to_install)
    parameters=Array.new
    softwares_to_install.each do | soft |
      puts soft[:infos][:filename]
      parameters.push({:name=>File.expand_path(soft[:infos][:filename]),:param=>soft[:infos][:install_param]}) 
    end
    #puts parameters.inspect
    #parameters = [{:name=>"c:\\Users\\silkmoth\\Downloads\\Opera-Next-12.50-1513.i386.exe",:param=>"/silent"}]
    parameters_string = Helpers::create_software_manager_param_string(parameters)
    puts parameters_string
    shell = WIN32OLE.new('Shell.Application')
    shell.ShellExecute('ruby.exe', software_manager + " -I " + parameters_string, nil, 'runas')
  end
end
# Check required conditions
if ARGV.empty?
  puts optparse
  exit
end
optparse.parse!