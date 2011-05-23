
User.all.each do |usr|
  next if usr.withings_userid.nil? or usr.withings_publickey.nil?

  wu = WiScale.new(:userid => usr.withings_userid, :publickey => usr.withings_publickey)

  status = wu.notify_get 'http://myhackerdiet.com/withings'

  if status == 247
    puts "FAILED: #{usr.id}\t#{usr.email}\t#{usr.withings_userid}\t#{usr.withings_publickey}"
  else
    puts "#{usr.id}\t#{usr.email}\t#{usr.withings_userid}\t#{usr.withings_publickey}\t#{Time.at(status.expires)}\t#{status.comment}"
  end
end

