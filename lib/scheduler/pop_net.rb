require 'scheduler.rb'

net_scheduler = Scheduler.new()
net_scheduler.ext = "net"
net_scheduler.file_name = "net.zone"
net_scheduler.start_text = "$TTL 172800"

net_scheduler.start()

