require 'win32/registry'
module InstalledSoftwares
  @list                   = []
  @names_list             = []
  @names_and_version_list = []
  Uninstall_Keys_Path = 'Software\Microsoft\Windows\CurrentVersion\Uninstall'
  #Uninstall_keys_Path_64 =  'Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall'
  KEY_WOW64_64KEY = 0x0100
  KEY_WOW64_32KEY = 0x0200
  #this list method doesn't work ( break when read the array @list of copied keys)
#  def self.list
    #check if system is 64 bits
#    key_read =nil
#    if self.get_os_version() == "AMD64"
      #read the registry for 64 bits softs 
#      key_read = KEY_WOW64_64KEY | Win32::Registry::Constants::STANDARD_RIGHTS_READ | Win32::Registry::Constants::KEY_QUERY_VALUE |Win32::Registry::Constants::KEY_ENUMERATE_SUB_KEYS |Win32::Registry::Constants::KEY_NOTIFY
#      Win32::Registry.open(Win32::Registry::HKEY_LOCAL_MACHINE,Uninstall_Keys_Path,key_read)do | reg |
#        reg.each_key do | key |
#          k = reg.open(key)
#          have_a_name = k["DisplayName"] rescue "n/a"
#          have_a_version = k["DisplayVersion"] rescue "n/a"
#          if have_a_name != "n/a" and have_a_version != "n/a"
#            @list.push(k.clone)
#          end
#        end
#      end
#    end
#    Win32::Registry::HKEY_LOCAL_MACHINE.open(Uninstall_Keys_Path) do | reg|   
#      reg.each_key do | key |
#        k = reg.open(key)
#        have_a_name = k["DisplayName"] rescue "n/a"
#        have_a_version = k["DisplayVersion"] rescue "n/a"
#        if have_a_name != "n/a" and have_a_version != "n/a"
#          #check that this key is not yet registred:
#          is_registred_yet = false
#          @list.each do | soft |
#            if soft["DisplayName"] == have_a_name and soft["DisplayVersion"] == have_a_version
#              is_registred_yet = true
#            end
#          end
#          if is_registred_yet == false
#            @list.push(k.clone)
#          end
#        end
#      end
#    end
#    Win32::Registry::HKEY_CURRENT_USER.open(Uninstall_Keys_Path) do | reg |
#      reg.each_key do | key |
#        k = reg.open(key)
#        have_a_name = k["DisplayName"] rescue "n/a"
#        have_a_version = k["DisplayVersion"] rescue "n/a"
#        if have_a_name != "n/a" and have_a_version != "n/a"
          #check that this key is not yet registred:
#          is_registred_yet = false
#          @list.each do | soft |
#            if soft["DisplayName"] == have_a_name and soft["DisplayVersion"] == have_a_version
#              is_registred_yet = true
#            end
#          end
#          if is_registred_yet == false
#            @list.push(k.clone)
#          end
#        end
#      end
#    end
#    return @list
#  end
  
  def self.names_list
    #check if system is 64 bits
    key_read =nil
    if self.get_os_version() == "AMD64"
      #read the registry for 64 bits softs 
      key_read = KEY_WOW64_64KEY | Win32::Registry::Constants::STANDARD_RIGHTS_READ | Win32::Registry::Constants::KEY_QUERY_VALUE |Win32::Registry::Constants::KEY_ENUMERATE_SUB_KEYS |Win32::Registry::Constants::KEY_NOTIFY
      Win32::Registry.open(Win32::Registry::HKEY_LOCAL_MACHINE,Uninstall_Keys_Path,key_read)do | reg |
        reg.each_key do | key |
          k = reg.open(key)
          have_a_name = k["DisplayName"] rescue "n/a"
          have_a_version = k["DisplayVersion"] rescue "n/a"
          if have_a_name != "n/a" and have_a_version != "n/a"
            @names_list.push(k["DisplayName"].clone)
          end
        end
      end
    end
    Win32::Registry::HKEY_LOCAL_MACHINE.open(Uninstall_Keys_Path) do | reg|
      reg.each_key do | key |
        k = reg.open(key)
        have_a_name = k["DisplayName"] rescue "n/a"
        have_a_version = k["DisplayVersion"] rescue "n/a"
        if have_a_name != "n/a" and have_a_version != "n/a"
          #check that this key is not yet registred:
          is_registred_yet = false
          @names_list.each do | soft |
            if soft == k["DisplayName"] 
              is_registred_yet = true
            end
          end
          if is_registred_yet == false
            @names_list.push(k["DisplayName"].clone)
          end
        end
      end
    end
    Win32::Registry::HKEY_CURRENT_USER.open(Uninstall_Keys_Path) do | reg|
      reg.each_key do | key |
        k = reg.open(key)
        have_a_name = k["DisplayName"] rescue "n/a"
        have_a_version = k["DisplayVersion"] rescue "n/a"
        if have_a_name != "n/a" and have_a_version != "n/a"
          #check that this key is not yet registred:
          is_registred_yet = false
          @names_list.each do | soft |
            if soft == k["DisplayName"]
              is_registred_yet = true
            end
          end
          if is_registred_yet == false
            @names_list.push(k["DisplayName"].clone)
          end
        end
      end
    end
    return @names_list
  end
  def self.names_and_version_list
    #check if system is 64 bits
    key_read =nil
    if self.get_os_version() == "AMD64"
      #read the registry for 64 bits softs 
      key_read = KEY_WOW64_64KEY | Win32::Registry::Constants::STANDARD_RIGHTS_READ | Win32::Registry::Constants::KEY_QUERY_VALUE |Win32::Registry::Constants::KEY_ENUMERATE_SUB_KEYS |Win32::Registry::Constants::KEY_NOTIFY
      Win32::Registry.open(Win32::Registry::HKEY_LOCAL_MACHINE,Uninstall_Keys_Path,key_read)do | reg |
        reg.each_key do | key |
          k = reg.open(key)
          have_a_name = k["DisplayName"] rescue "n/a"
          have_a_version = k["DisplayVersion"] rescue "n/a"
          if have_a_name != "n/a" and have_a_version != "n/a"
            an_hash = { :DisplayName => k["DisplayName"], :DisplayVersion => k["DisplayVersion"]}
            @names_and_version_list.push(an_hash.clone)
          end
        end
      end   
    end
    #this on 32 bits systems read the good registry keys and on 64 bits read the 32 bits related keys (\Software\wow6432node)
    Win32::Registry::HKEY_LOCAL_MACHINE.open(Uninstall_Keys_Path) do | reg|
      reg.each_key do | key |        
        k = reg.open(key)
        have_a_name = k["DisplayName"] rescue "n/a"
        have_a_version = k["DisplayVersion"] rescue "n/a"
        if have_a_name != "n/a" and have_a_version != "n/a"
          #check that this key is not yet registred:
          is_registred_yet = false
          @names_and_version_list.each do | soft |
            if soft[:DisplayName] == k["DisplayName"] and soft[:DisplayVersion] == k["DisplayVersion"]
              is_registred_yet = true
              #puts k["DisplayName"]
            end
          end
          if is_registred_yet == false
            an_hash = { :DisplayName => k["DisplayName"], :DisplayVersion => k["DisplayVersion"]}
            @names_and_version_list.push(an_hash.clone)
          end
        end
      end
    end
    Win32::Registry::HKEY_CURRENT_USER.open(Uninstall_Keys_Path) do | reg|
      reg.each_key do | key |
        k = reg.open(key)
        have_a_name = k["DisplayName"] rescue "n/a"
        have_a_version = k["DisplayVersion"] rescue "n/a"
        if have_a_name != "n/a" and have_a_version != "n/a"
          #check that this key is not yet registred:
          is_registred_yet = false
          @names_and_version_list.each do | soft |
            if soft[:DisplayName] == k["DisplayName"] and soft[:DisplayVersion] == k["DisplayVersion"]
              is_registred_yet = true
            end
          end
          if is_registred_yet == false
            an_hash = { :DisplayName => k["DisplayName"], :DisplayVersion => k["DisplayVersion"]}
            @names_and_version_list.push(an_hash.clone)
          end
        end
      end
    end
    return @names_and_version_list
  end
  def self.get_version_of( software)
    version = "n/a"
    #check if @names_and_version_list already initialized 
    if @names_and_version_list.length != 0
      @names_and_version_list.each do | soft_data |
        if soft_data[:DisplayName].downcase =~ /.*#{software.downcase}.*/
          puts "#############found"
          version = soft_data[:DisplayVersion]
        end
      end
    else
      self.names_and_version_list()
      version = self.get_version_of(software)
    end
    return version
  end
  def self.get_os_version()
    os_infos_key = 'SYSTEM\CurrentControlSet\Control\Session Manager\Environment'
    reg = Win32::Registry::HKEY_LOCAL_MACHINE.open(os_infos_key) 
    return reg['PROCESSOR_ARCHITECTURE']
  end
  def self.get_os_lang()
    langage=nil
    Win32::Registry::HKEY_LOCAL_MACHINE.open('SYSTEM\CurrentControlSet\Control\MUI\UILanguages') do | reg|
      reg.each_key do | key |
        langage= key
      end
    end
    return langage.gsub!(/\-..$/,"")
  end
end


#puts InstalledSoftwares::names_and_version_list.length
#puts InstalledSoftwares::names_list().length()
#puts InstalledSoftwares::list().length()

#all_names = InstalledSoftwares::names_list
#all_names.each do | n|
#  puts n
#end
#puts InstalledSoftwares::get_version_of("malwarebyte")
#n_and_v = InstalledSoftwares::names_and_version_list
#puts n_and_v.length()

#puts InstalledSoftwares::get_version_of("Malwarebyte")
