require "stringshit"
require "reads"

function love.load() 
	IMAGE_WIDTH = 32
	IMAGE_HEIGHT = 32
	SAMPLE_RATE = 10240
	IMAGE_FRAMES = 3
	TOTAL_FRAMES = 99

	filename = ""
	output_filename = "audio.wav"
	
	--render_data = love.image.newImageData(filename)
end

function love.keypressed(key)
	if key == "u" then -- write to wav

		wChannels = 1 -- mono
		dwSamplesPerSec = SAMPLE_RATE -- samplerate in Hz
		dwBitsPerSample = 8
		wBlockAlign = wChannels * (dwBitsPerSample / 8)
		dwAvgBytesPerSec = dwBitsPerSample * wBlockAlign	
		
		output = "RIFF"
		local filelengthplace = output:len()
		output = output .. string.char(0):rep(4) .. "WAVE" -- header (blank is dwFileLength)
		
		output = output .. "fmt " 
		local chunklengthplace = output:len()
		output = output .. tostr_W(16,4) .. tostr_W(1,2) -- format (blank is dwChunkSize)
		
		output = output .. tostr_W(wChannels,2) .. tostr_W(dwSamplesPerSec,4)
		output = output .. tostr_W(dwAvgBytesPerSec,4) .. tostr_W(wBlockAlign,2)
		output = output .. tostr_W(dwBitsPerSample,2)
		
		rest = output
		output = output .. "data" .. tostr_W(IMAGE_WIDTH*IMAGE_HEIGHT*TOTAL_FRAMES,4) -- data
		
		for k=0,TOTAL_FRAMES-1 do
			currentFrame = (k % IMAGE_FRAMES)+1
			fullFileName = "in/" .. filename .. string.format("%04d", currentFrame) .. ".png"
			print(fullFileName)
			if love.filesystem.getInfo(fullFileName) then
				render_data = love.image.newImageData(fullFileName)
		
				for j=0, IMAGE_HEIGHT-1 do
					for i=0, IMAGE_WIDTH-1 do
						output = output .. simple_avg_read(i,j)
					end
				end
			end

		end
		
		local filelen = string.len(output)-8
		rest = output
		output = "RIFF" .. tostr_W(filelen,4) .. string.sub(rest,9)
		
		file = io.open(output_filename,"wb")
		file:write(output)
		file:close()
		
		print("Finished writing to " .. output_filename)
	end
end

function love.update(dt)

end

function love.draw()
	
end