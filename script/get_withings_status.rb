
User.all.each do |usr|
  next if usr.withings_userid.nil? or usr.withings_publickey.nil?

  wu = WiScale.new(:userid => usr.withings_userid, :publickey => usr.withings_publickey)

  status = wu.notify_get 'http://myhackerdiet.com/withings'

  if status.class == Fixnum
    puts "FAILED (#{status}): #{usr.id}\t#{usr.email}\t#{usr.withings_userid}\t#{usr.withings_publickey}"

    begin
            wu.user_update 1
            wu.notify_subscribe 'http://myhackerdiet.com/withings', 'MyHackerDiet Withings'

            status = wu.notify_get 'http://myhackerdiet.com/withings'
            puts "\t\t\t\tSUBSCRIBED: #{Time.at(status.expires)}\t#{status.comment}"
    rescue
            puts "\t\t\t\tFAILED SUBSCRIBE"
    end
  else
    puts "#{usr.id}\t#{usr.email}\t#{usr.withings_userid}\t#{usr.withings_publickey}\t#{Time.at(status.expires)}\t#{status.comment}"
  end
end

