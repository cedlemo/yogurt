require 'open-uri'
require 'nokogiri'
require 'win32/registry'
#http://www.adobe.com/products/flashplayer/distribution3.html
module Adobe_flash_player_11_activex
  def self.last_version()
    infos={ :filename => nil, :version => nil, :url => nil,  :install_param => "-install", :err => nil}
    doc = Nokogiri::HTML(open("http://www.adobe.com/products/flashplayer/distribution3.html")) rescue nil
    if doc
      doc.xpath('//*[@id="bodycontent1"]/div[5]/div/div/table/thead/tr/th/h3').each do |node|
        if node.text =~ /.*Flash\sPlayer\s*[\d\.]*.*/
          node.text.match(/.*Flash\sPlayer\s*([\d\.]*).*/)
          infos[:version] = $1
        end
        #just get the first displayed version which is the last
        break
      end
      infos[:filename] = "Flash_Player_ActiveX-" + infos[:version]+ ".exe"
      #this has to be removed ( it downloads a downloader for the setup file and not the setup standalone setup file)
      #download_page = 'http://get.adobe.com/fr/flashplayer/download/?installer=Flash_Player_11_for_Internet_Explorer&os=Windows%207&browser_type=KHTML&browser_dist=Chrome&d=McAfee_Security_Scan_Plus_Chrome_Browser&dualoffer=false'
      #doc = Nokogiri::HTML(open(download_page))
      #doc.xpath('//head/script[@type = "text/javascript"]').each do | node |
      #  if node.text =~ /.*registerOnLoad.*/
      #    node.text.match(/location\.href\s=\s*\"([^\;]*)\"\;/)
      #    infos[:url] = $1

      #  end
      #end
      infos[:url] = "http://download.macromedia.com/get/flashplayer/current/licensing/win/install_flash_player_11_active_x.exe"
      return infos
    else
      infos =nil
      infos = { :err => "unable to open distant url check your connection, if it works this is a module problem", :module_name => "Adobe_flash_player_11_activex" }
    end
  end
end

#puts Adobe_flash_player_11_activex::last_version()[:version]