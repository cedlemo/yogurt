##Yogurt 

This is a ruby script for windows that helps me to manage softwares install and update. (tested under windows 7 x86/ x86_64 and windows server 2008 R2).
For now it just manages firefox, thunderbird, flash player active X, flash player plugin, ccleaner and inkscape.

###Installation:
just get the yogurt repository on your system.

###Dependancies:
*  ruby
*  nokogiri gem

###Usage:
ruby yogurt.rb OPTIONS

with OPTIONS :
    -h, --help                       
		Display this screen ( see -qh parameters for query help)
    -q, --query                      
		switch to query mod:
    -d, --download-updates [DIR]     
		Download all availables update in specified DIR (optionnal) or in default
    -I, --install [SOFT]             
		Install given software [SOFT] or all that are not installed (see -q --non-installed or -qi for a list)
    -U, --update										 
		Update all already installed softwares if it exists a newer version  
    -l, --managed-list               
		In query mod, display a list of the softwares that yougurt currently check
    -L, --installed-list             
		In query mod, display a list of all third party softwares installed
    -v SOFT_PAT, --installed-version 
		In query mod display the installed version if the software is installed
    -u, --available-update           
		In query mod display all new versions available of already installed softwares
    -i, --non-installed              
		In query mod, display a list of all softwares that are not installed

###How it works:

yogurt.rb is the main script which manages parameters

lib directory contains modules with specific or generic functions:
*  downloader
*  helpers
*  installed_softwares
*  software_manager
*  helpers

softwares_modules directory contains modules for each applications to manage
*  the name of the module file must be the name of the software where space become underscore ( i.e. Adobe_flash_player_11_plugin ) , case is not important 
*  the name of the module must be the same as the name of the file but with the first letter in uppercase and all the other in lower case.
*  the module has only one function which is Module_name.last_version(). This function return an hash :
*  infos[:url] the url for downloading the last version
*  infos[:filename] the name of the file of the last version installer
*  infos[:version] the version number of the last version
*  infos[:install_param] the parameters for silent install
*  infos[:err] the error message, nil if no errors.

yogurt.rb launch all that scripts module using eval statement.


