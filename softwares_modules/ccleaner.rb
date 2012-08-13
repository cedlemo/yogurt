require 'open-uri'
require 'nokogiri'

module Ccleaner
  def self.last_version()
    infos={ :filename => nil, :version => nil, :url => nil, :install_param => "\/S", :err => nil }
    #get last version number of ccleaner
    doc = Nokogiri::HTML(open("http://www.piriform.com/ccleaner/download")) rescue nil
    if doc
      doc.xpath('//div[@id="rc"]/div/div[@align="left"]/div[@style="border:0; padding:0 40px; line-height:1.5em;"]/p').each do |node|
        node.text.gsub!(/\s{2,}/," ")
        node.text.gsub!(/\n+/,"")
        node.text.gsub!(/\r+/,"")
        if node.text =~ /.*Latest version:.*/
          node.text.match(/.*Latest\sversion\:\s*([\d\.]*)/)
          infos[:version] = $1
        end
      end

      doc = Nokogiri::HTML(open("http://www.piriform.com/ccleaner/download/standard"))
      doc.xpath('//div[@id="bc"]/div[@id="content_blank"]/div[@id="content_full"]/div/div[@id="rc"]/div/div/center/a').each do | node |
        infos[:url] = node['href']
        infos[:filename] = URI(node['href']).path.gsub("\/","")
      end
      return infos
    else
      infos =nil
      infos = { :err => "unable to open distant url check your connection, if it works this is a module problem", :module_name => "Ccleaner" }
    end
  end
end

#a = Ccleaner.last_version
#puts a[:filename]
#puts a[:version]
#puts a[:url]