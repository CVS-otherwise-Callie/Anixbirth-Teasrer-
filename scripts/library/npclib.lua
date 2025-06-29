local mod = FHAC
local rng = RNG()
local game = Game()
local sfx = SFXManager()

function mod:textToAscii(char)
	local ascii = string.byte(char)

	return ascii - 32
end

function mod:npctalk(ef, sent, sentlen)
	local center = StageAPI.GetScreenCenterPosition()
	local bottomright = StageAPI.GetScreenBottomRight()
	local bcenter = Vector(center.X, bottomright.Y - 300)
	local loopcount = 0
	local sprite = ef:GetSprite()
	local charX = 0
	local charY = 0

	ef:SetColor(Color.Default, 2, 1, false, false)
	ef:GetData().letterdelay = 1
    ef.Visible = true
	while loopcount < sentlen do
		loopcount = loopcount + 1
		charX = charX + 1
		local letter = string.sub(sent,loopcount,loopcount)
		local ascii = mod:textToAscii(letter)
		if string.sub(sent,loopcount,loopcount) == [[\]] then
			local letter = string.sub(sent,loopcount + 1,loopcount + 1)

			--EFFECTS
			if letter == "W" then --white text
				ef:SetColor(Color.Default, 2, 1, false, false)
			end

			if letter == "Y" then --yellow text
				ef:SetColor(Color(1,1,0,1), 2, 1, false, false)
			end

			if letter == "L" then --new line
				charX = 1
				charY = charY + 1
			end

			if letter == "U" then
				if ef:GetData().letterdelay > 0 then
					ef:GetData().letterdelay = ef:GetData().letterdelay - 1
				end
			end

			if letter == "D" then
				ef:GetData().letterdelay = ef:GetData().letterdelay + 1
			end

			loopcount = loopcount + 1
			charX = charX - 1

		else
			sprite:SetFrame(ascii)
			sprite:Render(Vector(bcenter.X + (charX * 9) - 200, (Isaac.GetScreenHeight() - 45) + (charY * 13)), Vector.Zero, Vector.Zero)
		end
	end
	ef.Visible = false
	if sentlen >= #sent then
		return true
	else
		return false
	end
end

--Burslake Bestiary's Handy Dandy Code for morphing on death
