#!/usr/bin/env ruby

# main.command
# Organise By Date

#  Created by Mannie Tagarira on 23-12-2009.
#  Copyright (c) 2009 Emmanuel Tagarira, All Rights Reserved.

date = `date "+%Y-%m-%d"`.gsub("\n", "")
organise_dir = ""

ARGF.each do |f|
  f.gsub!("\n", "")
  f.gsub!(' ', '\ ')

  organise_dir_not_set = (organise_dir.empty? ? true:false)
  if organise_dir_not_set
    split = f.split("/")
    split.reject! { |x| x == split.last }
    organise_dir = split.join("/") + "/"
    `mkdir #{organise_dir + date}`
  end

  f_name = f.gsub(organise_dir, "")
  is_file = `if test -f #{f}; then echo "yes"; fi`
  
  if is_file =~ /yes/i
    f_name = "~" + f_name while `if test -f #{organise_dir + date}/#{f_name}; then echo "yes"; fi` =~ /yes/i
    `mv #{f} #{organise_dir + date}/#{f_name}`
  end
end

puts (organise_dir + date + "/").gsub('\ ', ' ')
