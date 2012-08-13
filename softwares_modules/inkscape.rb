require 'open-uri'
require 'nokogiri'

module Inkscape
  def self.last_version()
    infos={ :filename => nil, :version => nil, :url => nil, :install_param => "\/S", :err => nil }
    main_version = nil
    doc = Nokogiri::HTML(open("http://inkscape.org/")) rescue nil
      
    if doc
      node = doc.xpath('//body[@class = "index"]/div[@id= "wrapper"]/div[@class="downloadnow"]/span')
      node.text.match(/.*Latest\sstable\sversion\:\s*([\d\.]*)/) 
      main_version =$1
      puts main_version
      
      doc.xpath('//head/script').each do | node |
        if node.text.match(/(http\:\/\/downloads\.sourceforge\.net\/inkscape\/Inkscape.*\.exe)/)
          infos[:url] =  $1
        end
      end
      infos[:url].match(/http\:\/\/downloads\.sourceforge\.net\/inkscape\/Inkscape\-(.*)\.exe/)
      infos[:version] = $1
      infos[:filename] = "Inkscape-" + infos[:version]+ ".exe"
      infos[:url] = 'http://sourceforge.net/projects/inkscape/files/inkscape/'+ main_version + '/Inkscape-'+ infos[:version] + '-win32.exe/download'#?use_mirror=autoselect'
        #'http://sourceforge.net/projects/inkscape/files/inkscape/0.48.2/Inkscape-0.48.2-1-win32.exe/download'
      puts infos[:url]
    else
      infos =nil
      infos = { :err => "unable to open distant url check your connection, if it works this is a module problem", :module_name => "Inkscape" }
    end
    #puts 'http://downloads.sourceforge.net/project/inkscape/'+ main_version + '/Inkscape-'+ infos[:version] + '-win32.exedownload?use_mirror=autoselect'
    #doc = Nokogiri::HTML(open('http://sourceforge.net/projects/inkscape/files/latest/download?source=files'))
    #if doc
    #  puts "open"
    #  doc.xpath('//head/meta') do | node |
    #    puts node.text
    #  end
    #end      
    return infos
  end
end
Inkscape.last_version()