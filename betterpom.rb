require "csv"
require "progressbar"

$pom_count = 0
puts "Hi!"

class ProgressBar
  def eta
     if @current == 0
      "ETA:  --:--:--"
    else
      elapsed = Time.now - @start_time  
      sprintf("Elapsed: %s", format_time(elapsed)) 
    end
  end
end

def timer(minutes)
  started_at = Time.now
  finish_at = started_at + minutes * 60; #Credit for this timer to Thai Pangsakulyanont at Ruby Everyday
   pbar = ProgressBar.new("Progress", 100)
  while Time.now < finish_at; 
    percentage_done = (100 - (((finish_at - Time.now)/(finish_at - started_at))*100)).to_i
    pbar.set(percentage_done)
    #print "#{percentage_done}% | "
    #puts "Elapsed: #{((Time.now - started_at)/60).round(2)} mins | Remaining: #{((finish_at - Time.now)/60).round(2)}"
    #print "Elapsed: #{((Time.now - started_at) / 60).round(0)} minutes, #{((Time.now - started_at) % 60).round(0)} seconds | "
    #puts "Remaining: #{((finish_at -Time.now) / 60).round(0)} minutes, #{((finish_at - Time.now) % 60).round(0)} seconds "
    sleep 1;
  end
   pbar.finish
end

def pom_timer
#This runs the pomodoro timer
  puts "How long would you like your timer to run in minutes?"
  pom_length = gets.chomp.to_i

  if pom_length < 1
    puts "Please enter a whole number!"
    pom_length = gets.chomp.to_i
  else
    puts "Ok, here we go!"
  end

  timer(pom_length)
  $pom_count = $pom_count + 1 
  system ('say "Get up you are done you magnificent bastard"')

  unless File.exist?("derptest.csv")
    CSV.open("derptest.csv", "a+") do |row|
      row << ["Date", "Length", "Finish Time", "Work Content"]
    end
  end

  #This records to CSV file
  date = Time.now.strftime("%F")
  pom_finish_time = Time.now.strftime("%H:%M")
  puts "What did you work on?"
  pom_work_content = gets.chomp

  CSV.open("derptest.csv", "a+") do |row|
    row << [date, pom_length, pom_finish_time, pom_work_content]
  end

  #This runs the break timer
  puts "How long should your break be?"
  break_time = gets.chomp.to_i

  if break_time < 1
    puts "Please enter a whole number!"
    break_time = gets.chomp.to_i
  else
    puts "Ok, here we go!"
  end

  timer(break_time)

  system ('say "Okay now get back to work you old coot"')
  repeat_option
end

def repeat_option #This runs the repeat
  puts "Congratulations! You have done #{$pom_count} pomodoros this session!"
  puts "Would you like to do another pom? Answer yes or no." 
  repeat_request = gets.chomp

  if repeat_request == "yes"
    pom_timer
  elsif repeat_request == "no"
    puts "Good work today! See you soon."
  else
    puts "Please answer yes or no."
    repeat_option
  end
end


pom_timer #This actually runs the timer/break method



