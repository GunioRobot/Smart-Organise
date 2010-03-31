#!/usr/bin/env ruby

# main.command
# Smart-Organise Folders

#  Created by Emmanuel Tagarira on 2009-12-22.
#  Copyright (c) 2009 Emmanuel Tagarira, All Rights Reserved.

# ========================================

# This file is part of Smart-Organise.

# Smart-Organise is free software: you can redistribute it and/or modify it 
# under the terms of the GNU Lesser General Public License as published by the 
# Free Software Foundation, either version 3 of the License, or (at your option)  
# any later version.

# Smart-Organise is distributed in the hope that it will be useful, but WITHOUT 
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS 
# FOR A PARTICULAR PURPOSE.  See the GNU Lesser General Public License for more 
# details.

# You should have received a copy of the GNU General Public License along with 
# Smart-Organise.  If not, see <http://www.gnu.org/licenses/lgpl.html>.

# ========================================

organise_dirs = []

ARGF.each do |f|
  f.gsub!("\n", "/")
  f.gsub!(' ', '\ ')
  organise_dirs << f
end

organise_dirs.each do |organise_dir|
  files = `ls -p #{organise_dir}`.split("\n").reject { |x| x =~ /.*\/$/ }
  file_exts = []

  files.each do |file|
    ext = file.split('.')[-1]
    unless file_exts.include?(ext)
      `mkdir #{organise_dir + ext}`
      `mv -n #{organise_dir}*.#{ext} #{organise_dir + ext}`

      file_exts << ext
    end
  end

  files = `ls -p #{organise_dir}`.split("\n").reject { |x| x.end_with?('/') }
  files = files.select { |x| x.split(".").size > 1 }

  until files.empty?
    f_name = files.first
    f_name.gsub!("\n", "")
    f_name.gsub!(' ', '\ ')
    f_name.gsub!(organise_dir, "")
    ext = f_name.split('.')[-1]
    orig_f_name = f_name
    f_name = "~" + f_name while `if test -f #{organise_dir + ext}/#{f_name}; then echo "yes"; fi` =~ /yes/i
    `mv #{organise_dir + orig_f_name} #{organise_dir + ext}/#{f_name}`
    files.reject! { |x| x == files.first }
  end

# This code is to remove empty folders from the smart-organise folder!
#
#  blacklist = %w{ . .. .DS_Store }  
#  `ls -p #{organise_dir}`.split("\n").each do |ext|
#    sub_dir_contents = `ls -p #{organise_dir + ext}`.split("\n")
#    sub_dir_contents.reject!{ |x| blacklist.include?(x) }
#    `rm -rf #{organise_dir + ext}` if sub_dir_contents.empty?
#    puts "#{organise_dir + ext} => #{sub_dir_contents.empty?}"
#  end
end
