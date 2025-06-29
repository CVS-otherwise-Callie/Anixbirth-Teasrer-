local mod = FHAC
local rng = RNG()
local game = Game()
local sfx = SFXManager()

function mod:textToAscii(char)
	local ascii = string.byte(char)

	return ascii - 32
end

function mod:textEffect(ef, letter)
	if letter == "W" then
		ef:SetColor(Color.Default, 2, 1, false, false)
		--return "W (ts in func)"
	end
	if letter == "Y" then
		ef:SetColor(Color(1,1,0,1), 2, 1, false, false)
		--return "Y (ts in func)"
	end
	if letter == "L" then
		ef:GetData().charY = ef:GetData().charY + 1
		ef:GetData().charX = 0
	end
end

--Burslake Bestiary's Handy Dandy Code for morphing on death
