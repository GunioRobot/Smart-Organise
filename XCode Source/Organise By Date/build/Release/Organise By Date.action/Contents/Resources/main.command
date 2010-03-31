#!/usr/bin/env ruby

# main.command
# Organise By Date

#  Created by Emmanuel Tagarira on 2009-12-23.
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
