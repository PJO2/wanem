#!/usr/bin/ruby
# --------------------------
# use tc to change interface delay, jitter, loss and bandwidth parameters
# supports only tbf but enough for us
# --------------------------


def set_itf_status( itf, params )
  tc_out = ''

  delay = params[:delay].to_i
  loss = params[:loss].to_i
  jitter = params[:jitter].to_i
  bandwidth = params[:bandwidth].to_i
  if ( m = params[:bandwidth].match( /\d+\s*([KMG])(?:b|bit|bits)?$/i ) )
      bandwidth_unit = m.captures[0] + 'bit'
  else
      bandwidth_unit = "Kbit"
  end


  # override delay and jitter
  if  jitter>0
     jitter /= 2
     delay += jitter
  end

  # call netem 
  `/sbin/tc qdisc del dev #{itf} root`
  tc_out += `/sbin/tc qdisc add dev #{itf} root handle 1:0 netem delay #{delay}ms #{jitter}ms loss #{loss}%`
  if  bandwidth>0 
     tc_out += `/sbin/tc qdisc add dev #{itf} root handle 1:0`
     tc_out += `/sbin/tc qdisc add dev #{itf} parent 1:1 handle 10: tbf rate #{bandwidth}#{bandwidth_unit} buffer 3200 limit 32768`
  end

  tc_out += "/sbin/tc qdisc show dev #{itf}\n"
  tc_out += `/sbin/tc qdisc show dev #{itf}`
  return tc_out
end



