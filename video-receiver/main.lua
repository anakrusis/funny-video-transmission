function love.load() 

	IMAGE_WIDTH = 32
	IMAGE_HEIGHT = 32

	contrast = 1
	
	recordingDevices = love.audio.getRecordingDevices()
	device = recordingDevices[2]
	if device then
		name = device:getName()
		samplerate = device:getSampleRate()
		success = device:start( 16384, 10240, 16, 1 )
	end
	
	render_data = love.image.newImageData( IMAGE_WIDTH, IMAGE_HEIGHT )
	
	currentFrame = 0
	currentTick = 0
	currentX = 0
	currentY = 0
	
	hpos = 0
	vpos = 0
end

function love.update(dt)
	if (currentTick % 6) then
		sounddata = device:getData()
		if sounddata and not paused then
	
			for i=0, sounddata:getSampleCount()-1 do
			
				sample = sounddata:getSample(i)
				sample = sample * contrast
				sample = (sample + 1)/2
					
				x_pixel = ( currentX + hpos ) % render_data:getWidth()
				y_pixel = ( currentY + vpos ) % render_data:getHeight()
				
				if (x_pixel < render_data:getWidth() and y_pixel < render_data:getHeight()) then
					render_data:setPixel(x_pixel, y_pixel, sample, sample, sample, 1)
				end
				
				currentX = currentX + 1
				if (currentX == IMAGE_WIDTH) then 
					currentX = 0 
					currentY = currentY + 1
					render = love.graphics.newImage(render_data)

					--render_data = love.image.newImageData( IMAGE_WIDTH, IMAGE_HEIGHT )
				end
				if (currentY == IMAGE_HEIGHT) then
					currentX = 0
					currentY = 0
					currentFrame = currentFrame + 1
				end

			end
		end
		
		hpos = hpos - 0.036
	end
	
	if love.keyboard.isDown("up") then
		vpos = vpos + 1
	elseif love.keyboard.isDown("down") then
		vpos = vpos - 1
	end
	if love.keyboard.isDown("left") then
		hpos = hpos + 1
	elseif love.keyboard.isDown("right") then
		hpos = hpos - 1
	end
	--if (currentFrame % 130 == 0) then hpos = hpos - 1 end
end

function love.wheelmoved(x, y)
	contrast = contrast + (y * 2)
end

function love.keypressed(key)
	if key == "space" then
		paused = not paused
	end
end

function love.draw()
	love.graphics.setColor(1,1,1)
	if (name) then
		love.graphics.print(name)
		love.graphics.print(samplerate, 0, 20)
		love.graphics.print("Contrast: " .. contrast, 0, 40)
		if sounddata then
		love.graphics.print("Samp: " .. sounddata:getSampleCount(), 0, 60)
		love.graphics.print("Size: " .. sounddata:getSize(), 0, 80)
		end
	end	
	
	if sample then
		love.graphics.setColor(sample,sample,sample)
		love.graphics.rectangle("fill",100,100,50,50)
	end
	
	love.graphics.setColor(1,1,1)
	if (render) then
		love.graphics.draw(render, 200, 100, 0, 12, 12)
	end
end