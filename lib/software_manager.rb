require 'optparse'
require './lib/helpers.rb'
require 'win32ole'
def install ( all_softs)
  all_softs.each do | soft|
    puts "install #{File.basename(soft[:name])} .."
    puts File.dirname(soft[:name])
    shell = WIN32OLE.new('Shell.Application')
    shell.ShellExecute(soft[:name], soft[:param], File.dirname(soft[:name]),nil, nil)
  end
end

optparse = OptionParser.new do|opts|
  opts.banner='Usage:'
  opts.on( '-I PARAMS', '--install PARAMS', String, 'install all softs' ) do | s |

    a = Helpers.read_software_manager_param_string(s)
    puts a.inspect
    install(a)
  end
  opts.on( '-R PARAMS', '--remove PARAMS', String, 'remove all softs' ) do | s |

    a = Helpers.read_software_manager_param_string(s)
    puts a.inspect
  end
end
optparse.parse!
sleep 10
