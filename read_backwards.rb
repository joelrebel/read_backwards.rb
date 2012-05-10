class File

  def read_chunk(n, pos, fh, is_lastchunk)
      return [] if (n < 0 || n.nil?)
      fh.pos=pos
      buf = fh.read(n)
      return buf
  end
  
  def split_chunk(chunk, is_last_chunk)
  	str_buf = chunk.split("\n")
  	if $str_half.nil? 
  		 $str_half = str_buf.first
  	else
  		if chunk =~ /\n$/ # incase we have a chunk that ends up being a complete line
  			str_buf.push($str_half)
  		else
  			str_buf[-1] = str_buf[-1].concat($str_half)
  		end	
  		$str_half = str_buf.first
  	end
  	if ! is_last_chunk
  		str_buf.delete_at(0)
  	end	
  	str_buf.reverse
  end
  
  def read_backwards
  fsize = self.lstat.size
  chunksz=2048
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
  
  loop {
  	count += 1
  	chunk = read_chunk(chunksz, fpos, self, is_lastchunk)
  	lines = split_chunk(chunk, is_lastchunk)
  	#puts lines.inspect
  	lines.each{ |line|
  		yield line
  	}	
  	#puts '-------------X'
  
  	#puts '1 - chunk ->' + count.to_s + ' fpos->' + fpos.to_s +   'nextpos-> ' + (fpos-chunksz).to_s + 'chunksz->' + chunksz.to_s
  	if fpos <= chunksz*2
  		chunksz = fpos
  		fpos = 0
  	  	is_lastchunk=1
  	else
  		fpos = fpos - chunksz
  	end
  
  	#puts '2 - chunk ->' + count.to_s + ' fpos->' + fpos.to_s +   'nextpos-> ' + (fpos-chunksz).to_s + 'chunksz->' + chunksz.to_s
  	break if ((fpos && (fpos-chunksz)) == 0 )
  }
  end
end
