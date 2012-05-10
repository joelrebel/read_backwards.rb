A ruby implementation to read a file backwards
=====

 The idea behind this read_backwards implementation is to allow the user to read upwards from the end of the file as far as needed, e.g upto a certain timestamp value - log parsing fun.

example usage

    require 'read_backwards.rb'
    f = File.open('test')
    f.read_backwards{ |line|
   	 	#do stuff, like read upto the last hour, or secs or mins
    }

- the script is optimized to read in chunks and spit out data, reading from the end of the file.
- the idea behind reading in chunks would be to reduce the number of lseek syscalls that result when trying to read a file backwards, 
- use higher chunk values when reading larger files.
