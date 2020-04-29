-- All read algorithms will multiply the pixel value, a float between 0 and 1,
-- into an integer between 0 and 255, and then convert the integer to a binary string.

function float2int(float) -- ...And this is how to do it (the first part)!!!
	return math.ceil(float*255)
end

function simple_avg_read(x,y) -- Simply averages the R, G and B values, and returns them.

	if x < render_data:getWidth() and x >= 0 and y < render_data:getHeight() and y >= 0 then
		r,g,b = render_data:getPixel(x,y)
		avg = (r+g+b)/3
		
		--avg = (avg * 0.8) + 0.1
		
		avg = float2int(avg)
	else
		avg = 128
	end

	return string.char(avg)
end