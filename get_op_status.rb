#!/usr/bin/ruby

# kernel interface for network queries


# --------------------------
# returns interfaces name orderd by name
# --------------------------
def get_network_interfaces
   # get non virtual interface name looking in /sys/class/net 
   cli_output = `ls -l /sys/class/net/ | tail -n +2 | grep -v virtual | cut -d' ' -f9 | sort`
   return  cli_output.split("\n")
end
   



# --------------------------
# parse tc output and retrieve delay, jitter, loss and bandwidth parameters
# supports only tbf but enough for us
# --------------------------

# return a hash containing operationnal tc values
def get_itf_tc_data(itf)
   # empty settings:
   tc_data = { delay: 0, jitter: 0, loss: 0, bandwidth: "unlimited" }

   # call tc show
   tc_out =  `/sbin/tc qdisc show dev #{itf}` 
   # and parse it
   if  (m = tc_out.match( /rate (\S+) / ) )
       tc_data[:bandwidth] = m.captures[0]    
   end
   if  (m = tc_out.match( /delay (\d+).0ms(?:  (\d+).0ms)?/) )
       tc_data[:jitter] = m.captures[1].to_i * 2    if m.captures[1]
       tc_data[:delay] = m.captures[0].to_i - tc_data[:jitter]/2
      
   end
   if  (m = tc_out.match( /loss (\d+)%/ ) )
       tc_data[:loss] = m.captures[0]    
   end

   return tc_data
end


# ---------------------------
# return down/up status and #bytes
# ---------------------------
def get_itf_ip_data(itf)
   ip_data = { status: '', inpkts: 0, outpkts: 0 }
   # call ip link show
   ip_out = `ip link show #{itf}`
   if (m = ip_out.match( /state (UP|DOWN)/) )
      ip_data[:status] = m.captures[0].downcase
   end
   # call cat /sys/class/net/<itf>/statistics
   ip_data[:inpkts] = `cat /sys/class/net/#{itf}/statistics/rx_packets`
   ip_data[:outpkts] = `cat /sys/class/net/#{itf}/statistics/tx_packets`
   return ip_data
end


# ---------------------------
# return lldp neighbor
# ---------------------------
def get_itf_lldp_data(itf)
   lldp_data = { neighbor: '' }
   lldp_out = `/usr/sbin/lldpctl -f plain #{itf} | grep SysName | awk '{print $2}' | uniq`
   lldp_data[:neighbor] = lldp_out
   return lldp_data
end

# -------------
# get operationnal op_data for all interfaces
def get_op_data nics
# ---------------------------
   op_datas = {}
   nics.each do  |nic|   
        op_datas[nic] = get_itf_tc_data nic 
        op_datas[nic].merge!( get_itf_ip_data nic )
        op_datas[nic].merge!( get_itf_lldp_data nic )
   end
   return op_datas
end


# ---------------------------
# -- self tests
# ---------------------------
if __FILE__ == $0
   print get_network_interfaces
end

