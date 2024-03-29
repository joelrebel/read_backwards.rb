class File

  def read_chunk(n, pos, fh, is_lastchunk)
      return [] if (n < 0 || n.nil?)
      fh.pos=pos
      buf = fh.read(n)
      return buf
  end
  
  def split_chunk(chunk, delimiter, is_last_chunk, str_half)
  	str_buf = chunk.split(delimiter)
  	if str_half.nil? 
  		 str_half = str_buf.first
  	else
  		if chunk[-1..-1] == "\n"
  			str_buf.push(str_half)
  		else
  			str_buf[-1] = str_buf[-1].concat(str_half)
  		end	
  		str_half = str_buf.first
  	end
  	if ! is_last_chunk
  		str_buf.delete_at(0)
  	end	
  	[str_buf.reverse, str_half]
  end
  
  def read_backwards(chunksz=1024, delimiter="\n")
  fsize = self.lstat.size
  if fsize <= chunksz
  	fpos = 0
  	chunksz = fsize
  	is_lastchunk = 1
  else	
  	is_lashchunk = 0
  	fpos = fsize - chunksz
  end	
  
  lines=Array.new
  count = 0

  str_half = nil
  
  loop {
  	count += 1
  	chunk = read_chunk(chunksz, fpos, self, is_lastchunk)

  	lines, str_half = split_chunk(chunk, delimiter, is_lastchunk, str_half)
  	#puts lines.inspect
  	lines.each{ |line|
  		yield line
  	}	
  	#puts '-------------X'
  
 # 	$stdout << "\n" + '1 - chunk ->' + count.to_s + ' fpos->' + fpos.to_s +   'nextpos-> ' + (fpos-chunksz).to_s + 'chunksz->' + chunksz.to_s
  	if fpos <= chunksz*2
  		chunksz = fpos
  		fpos = 0
  	  	is_lastchunk=1
  	else
  		fpos = fpos - chunksz
  	end
  
#	$stdout << "\n" + '2 - chunk ->' + count.to_s + ' fpos->' + fpos.to_s +   'nextpos-> ' + (fpos-chunksz).to_s + 'chunksz->' + chunksz.to_s
  	break if ((fpos && (fpos-chunksz)) == 0 )
  }
  end
end
