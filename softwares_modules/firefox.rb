require 'open-uri'
require 'nokogiri'
require 'win32/registry'

module Firefox
  def self.last_version()
    infos={ :filename => nil, :version => nil, :url => nil, :install_param => "\/S", :err => nil }
    #get the language we need
    langage = ''
    Win32::Registry::HKEY_LOCAL_MACHINE.open('SYSTEM\CurrentControlSet\Control\MUI\UILanguages') do | reg|
      reg.each_key do | key |
        langage= key
      end
    end
    if langage == langage.gsub(/\-..$/,"") + "-" + langage.gsub(/\-..$/,"").upcase
      langage.gsub!(/\-..$/,"")
    end
   
    #get last version number of firefox
    doc = Nokogiri::HTML(open("http://www.mozilla.org/en-US/firefox/all.html")) rescue nil
    if doc
      doc.xpath('//table[@class = "downloads dalvay-table"]/tbody/tr[@id = "' + langage + '"]/td[@class="curVersion"]').each do |node|
        infos[:version] = node.text
      end
      infos[:filename] = "firefox-" + infos[:version]+ ".exe"
      #get download url
      doc.xpath('//table[@class = "downloads dalvay-table"]/tbody/tr[@id = "' + langage + '"]/td/a[@class="download-windows"]').each do |node|
        infos[:url] = node['href']
      end
      return infos
    else
      infos =nil
      infos = { :err => "unable to open distant url check your connection, if it works this is a module problem", :module_name => "Firefox" }
    end
  end
end

#a = Firefox.last_version

#puts a[:filename]
#puts a[:version]
#puts a[:url]