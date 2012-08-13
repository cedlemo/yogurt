module Helpers
  def self.create_software_manager_param_string( an_array)
    #an array is an array of hashs {:name => "test.exe", :param => "\\s"
    param_string ="nb="+an_array.length.to_s
    an_array.each do | entry |
      param_string+=";name=#{entry[:name]},param=#{entry[:param]}"
    end
    return param_string
  end
  def self.read_software_manager_param_string(a_string)
    string_in_array = a_string.split(";")
    #check size:
    nb_args = string_in_array.first.gsub(/^nb=/,"").to_i
    if nb_args != (string_in_array.length - 1)
      puts "bad parameters"
    else
      string_in_array.shift
    end
    parameters = Array.new
    string_in_array.each do | entry |
      an_hash = Hash.new()
      name, param = entry.split(",")
      an_hash = { :name => name.gsub(/^name=/,""), :param => param.gsub(/^param=/,"") }
      parameters.push(an_hash.clone)
    end
    return parameters
  end
end