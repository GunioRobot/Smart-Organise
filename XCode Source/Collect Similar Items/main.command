#!/usr/bin/env ruby

# main.command
# Collect Similar Items

#  Created by Mannie Tagarira on 22-12-2009.
#  Copyright (c) 2009 Emmanuel Tagarira, All Rights Reserved.

organise_dir = ""
file_exts = []

ARGF.each do |f|
  f.gsub!("\n", "")
  f.gsub!(' ', '\ ')

  ext = f.split(".")[-1]

  organise_dir_not_set = (organise_dir.empty? ? true:false)
  if organise_dir_not_set
    split = f.split("/")
    split.reject! { |x| x == split.last }
    organise_dir = split.join("/") + "/"
  end
  
  `mkdir #{organise_dir + ext}`
  `mv -n #{organise_dir}*.#{ext} #{organise_dir + ext}`
  files = `ls -p #{organise_dir}`.split("\n").select { |x| x.end_with?(".#{ext}") }

  until files.empty?
    files = `ls -p #{organise_dir}`.split("\n").select { |x| x.end_with?(".#{ext}") }
    f_name = files.first
    f_name.gsub!("\n", "")
    f_name.gsub!(' ', '\ ')
    f_name.gsub!(organise_dir, "")
    orig_f_name = f_name
    f_name = "~" + f_name while `if test -f #{organise_dir + ext}/#{f_name}; then echo "yes"; fi` =~ /yes/i
    `mv #{organise_dir + orig_f_name} #{organise_dir + ext}/#{f_name}`
    files.reject! { |x| x == files.first }
  end

  file_exts << ext
end
