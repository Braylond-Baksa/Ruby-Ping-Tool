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
#ipconfig
ipString = `ipconfig`
puts ipString
#get list of ip and mac addresses on network
localIPString = `arp -a`
ipLineCount = localIPString.lines.count - 3
count = 0
ipArr= Array.new(ipLineCount)
#parse string to find just ip and mac addresses
localIPString.each_line do|line|
  if count>2
    ip = line[2,15]
    mac = line[24,17]
    newIP = IpData.new(ip, mac)
    ipArr[count-3] = newIP

  end
  count = count+1
end
count = 0
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

    if ping.include? thisIP.getIP.strip
      if ping.include? "Destination host unreachable" or ping.include? "Request timed out"
        puts "ip: #{thisIP.getIP} MAC Address: #{thisIP.getMac} Ping: Unsuccessful"
      else
        puts "ip: #{thisIP.getIP} MAC Address: #{thisIP.getMac} Ping: Successful"
      end
      break
    end
  }
}
