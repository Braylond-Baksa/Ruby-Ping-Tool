#Class for storing IP info
class IpData
  def initialize(ip,mac)
    @ipAddress = ip
    @macAddress = mac
  end
  def getIP
    @ipAddress
  end
  def getMac
    @macAddress
  end
end

ipString = nil
localIPString = nil

input_array = ARGV
input_array.each {|arg|
  puts arg
 if arg.match /arp.txt/
    puts "arp found"
   localIPString = File.read(arg)
 end
 if arg.match /ipconfig.txt/
   puts "ipconfig found"
   ipString = File.read(arg)
 end
}


#ipconfig
if ipString.nil?
  ipString = `ipconfig`
end
puts ipString
#get list of ip and mac addresses on network
if localIPString.nil?
  localIPString = `arp -a`
end
puts localIPString

ipArr= []
#parse string to find just ip and mac addresses
localIPString.each_line do|line|
  if line.match /\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}/

    if  line.match /\w{2}-\w{2}-\w{2}-\w{2}-\w{2}-\w{2}/

      ip = line.match /(\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3})/
      mac = line.match /(\w{2}-\w{2}-\w{2}-\w{2}-\w{2}-\w{2})/
      newIP = IpData.new(ip, mac)
      ipArr << newIP

    end
  end
end

ipNum = ipArr.count
puts "Number of potential IP addresses: #{ipNum} "
puts
puts "IPList:"
puts
puts "Pinging IP addresses..."
#pings each ip address # times with a max of 10 threads running simultaniously
threads = []
pings = []
ipArr.each {|thisIP|
  puts thisIP.getIP
  ip = thisIP.getIP
  while
    if Thread.list.count <= 10
      threads << Thread.new{pings << `ping #{ip}`
                            pings << `ping #{ip}`
                            pings << `ping #{ip}`}
      break
    else
        threads.each(&:join)
    end
  end

}
  threads.each(&:join)
puts
puts "Results:"
puts
#shows results of ping for each ip address/ mac address
ipArr.each{|thisIP|

  pings.each{|ping|
    ip = thisIP.getIP
    if ping.include? ip[1]
      if ping.include? "Destination host unreachable" or ping.include? "Request timed out"
        puts "ip: #{thisIP.getIP} MAC Address: #{thisIP.getMac} Ping: Unsuccessful"
      else
        puts "ip: #{thisIP.getIP} MAC Address: #{thisIP.getMac} Ping: Successful"
      end
      break
    end
  }
}
