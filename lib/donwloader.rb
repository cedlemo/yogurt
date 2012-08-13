require "net/http"
#from http://stackoverflow.com/questions/2263540/how-do-i-download-a-binary-file-over-http-using-ruby
#and http://ruby-doc.org/stdlib-1.9.3/libdoc/net/http/rdoc/Net/HTTP.html#method-c-start (Streaming Response Bodies part)

module Downloader
#  def self.get(filename, url)
#    #check for the filename
#    path_check = true
#    if (path = File.dirname(filename)) != "." 
#      #the filename is a complete path check if exist:
#      path_check = File.directory?(path)    
#    else
#      #the filename is relative path
#      filename = File.expand_path(filename)
#    end
#    if path_check
#      #check for the url
#      uri = URI(url)
#      result= nil
#      #check for the connection
#      begin
#        Net::HTTP.start(uri.host, uri.port) do |http|
#          request = Net::HTTP::Get.new uri.request_uri
#          http.request request do |response|
#            #puts response.content_length
#            open filename, 'wb' do |io|
#              response.read_body do |chunk|
                #puts chunk.length
#                io.write chunk
#              end
#            end
#          end
#        end
#        result = { :is_ok => true, :err_mes => nil}
#      rescue SocketError
#        result = { :is_ok => false, :err_mes => "bad url"}
#      end
#    else
#      result = { :is_ok => false, :err_mes => "bad filename"}
#    end
#    return result
#  end
  def self.get(uri_str, filename, limit = 10)
    result = nil
    location = uri_str
    #check for the filename
    path_check = true
    if (path = File.dirname(filename)) != "." 
    #the filename is a complete path check if exist:
      path_check = File.directory?(path)
    else
    #the filename is relative path
      filename = File.expand_path(filename)
    end
    
    if path_check == false
      result = {:is_ok => false, :err_mes => 'bad filename'}
    elsif limit == 0  
      result = {:is_ok => false, :err_mes => 'too many HTTP redirects'}
    else
      uri = URI(uri_str) rescue nil
      if uri  
        url = URI.parse(uri_str)
        query = url.query ? "?" + url.query : ""
        fragment = url.fragment ? "#" + url.fragment : ""
        req = Net::HTTP::Get.new(url.path + query + fragment)
        Net::HTTP.start(url.host, url.port) do |http| 
          http.request(req) do | response |
            case response
            when Net::HTTPSuccess then
              open filename, 'wb' do |io|
                response.read_body do |chunk|
                  io.write chunk
                end
              end
              result = { :is_ok => true, :err_mes => "success"}
            when Net::HTTPRedirection then
              location = response['location']
              warn "redirected to #{location}"
              result = self.get(location, filename, limit - 1)
            else
              warn "no file or redirection http error: #{response.value}"
              result = { :is_ok => false, :err_mes => response.value}
            end
          end
        end
      else
        result = { :is_ok => false, :err_mes => "bad url"}
      end
    end
    return result
  end
end
#filename = "thunderbird-fr-14.0.exe"
#url = "http://download.mozilla.org/?product=thunderbird-14.0&os=win&lang=fr"
#url="http://ftp-stud.hs-esslingen.de/pub/Mirrors/ftp.mozilla.org/pub//thunderbird/releases/14.0/win32/fr/Thunderbird%20Setup%2014.0.exe"
#err= Downloader::get(url, filename )
#puts err[:is_ok]
#puts err[:err_mes]
