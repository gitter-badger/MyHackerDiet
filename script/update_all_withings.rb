
User.all.each do |usr|
  next if usr.withings_userid.nil? or usr.withings_publickey.nil?

  wu = WiScale.new(:userid => usr.withings_userid, :publickey => usr.withings_publickey)

  status = wu.notify_get 'http://myhackerdiet.com/withings'

  if status.class != Fixnum
    puts "#{usr.id}\t#{usr.email}\t#{usr.withings_userid}\t#{usr.withings_publickey}\t#{Time.at(status.expires)}\t#{status.comment}"
    puts "Updating from #{usr.weights.all.count} ...."
    Withings.import_withings usr.id, usr.withings_userid, usr.withings_publickey
    puts "now #{usr.weights.all.count}"
  end
end

