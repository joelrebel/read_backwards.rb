what?
=====

A ruby implementation to read a file backwards
=====

 The idea behind this read_backwards implementation is to allow the user to read upwards from the bottom up of the file upto as far as  needed, e.g upto a certain timestamp value - log parsing fun.
 

example usage

    require 'read_backwards.rb'
    f = File.open('test')
    f.read_backwards{ |line|
   	 	#do stuff, like read upto the last hour, or secs or mins
    }

example usage - by specifying the chunksize, delimiter

    require 'read_backwards.rb'
    f = File.open('test')
    f.read_backwards(chunksz=2048, delimiter="\t") {|line|
    		# cool stuff here
    }
why?
=====
 few reasons to read a log file from the bottom up -
 a. prevent messing up the system cache by reading from the top. 
 b. to be awesome and read up data from the logfile for just the last hour or two.

how?
=====
- the script reads in chunks and spits out data, starting from the end of the file.
- the idea behind reading in chunks would be to reduce the number of lseek syscalls that result when reading a file backwards, 
- use higher chunk values when reading larger files.
