-- GENERAL SETTING --
BuyBGEMS = false
DropBGEMS = true
EatBGEMS = false

-- AUTO CV GEMS TO DL --
EVADE_TAXES = false
TELEPHONE_X = 78 -- Set TILE X FOR TELEPHONE (wrench x -1 = you tile)
TELEPHONE_Y = 24 -- Set TILE Y FOR TELEPHONE (wrench y -1 = you tile)

-- DROP BGEMS SETTING --
bgemsamount = 7250
delay = 70

-- Load the main script
Load(MakeRequest("https://rentry.co/e6n3b4un/raw","GET").content)()
