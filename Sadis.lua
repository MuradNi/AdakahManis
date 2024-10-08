-- Load config
local BuyBGEMS = BuyBGEMS
local DropBGEMS = DropBGEMS
local EatBGEMS = EatBGEMS
local EVADE_TAXES = EVADE_TAXES
local TELEPHONE_X = TELEPHONE_X
local TELEPHONE_Y = TELEPHONE_Y
local bgemsamount = bgemsamount
local delay = delay

local function fetchUIDs()
    local success, response = pcall(function()
        return HttpGet("https://raw.githubusercontent.com/MuradNi/lock_uid.json/main/lock_uids.json")
    end)
    
    if success then
        local success, data = pcall(function()
            return JsonDecode(response)
        end)
        
        if success and type(data) == "table" and data.uids then
            return data.uids
        else
            LogToConsole("Error decoding UID data")
            return {}
        end
    else
        LogToConsole("Error fetching UID data")
        return {}
    end
end

-- Jika UID terverifikasi, lanjutkan dengan script utama
local start = true
local idk = 0
local metoo = bgemsamount / 250

local function GetItemCount(id)
    for _, item in pairs(GetInventory()) do
        if item.id == id then
            return item.amount
        end    
    end
    return 0
end

AddHook("onvariant", "mommy", function(var)
        if var[0] == "OnDialogRequest" and var[1]:find("end_dialog|social") then
        return true
    end
    if var[0]:find("OnDialogRequest") and var[1]:find("telephone") then
        return true
    end
    if var[0]:find("OnDialogRequest") and var[1]:match("set_default_color") then
        return true
    end
    if var[0]:find("OnStoreRequest") and var[1]:match("set_default_color") then
        return true
    end
    if var[0] == "OnDialogRequest" and var[1]:find("end_dialog|givexgems") then
        return true
    end
    return false
end)

local function findItem(id)
    count = 0
    for _, inv in pairs(GetInventory()) do
        if inv.id == id then
            count = count + inv.amount
        end
    end
    return count
end

local function convert(id)
    pkt = {}
    pkt.value = id
    pkt.type = 10
    SendPacketRaw(false, pkt)
end

local function dropbgems()
   if DropBGEMS then
        if idk >= metoo then
            LogToConsole("done. Dropped "..bgemsamount.." bgems at the floor")
            start = false
        elseif idk < metoo then
            SendPacket(2, "action|dialog_return\ndialog_name|popup\nbuttonClicked|bgem_dropall")
            idk = idk + 1
            Sleep(delay)
        end
    end
end

local function eatbgems()
    if EVADE_TAXES then
        if GetPlayerInfo().gems <= 200000 then
            if EatBGEMS then
                SendPacket(2, "action|dialog_return\ndialog_name|givexgems\nitem_id|-484|\nitem_count|250")
                Sleep(100)
            end
        end
    elseif not EVADE_TAXES then
        if EatBGEMS then
            SendPacket(2, "action|dialog_return\ndialog_name|givexgems\nitem_id|-484|\nitem_count|250")
            Sleep(100)
        end
    end
end

local function buybgems()
    if BuyBGEMS then
        SendPacket(2, "action|dialog_return\ndialog_name|vend_buy\nx|"..math.floor(GetLocal().pos.x /32).."|\ny|"..math.floor(GetLocal().pos.y /32).."\nbuyamount|250")
        Sleep(300)
        SendPacket(2, "action|dialog_return\ndialog_name|vend_buyconfirm\nx|"..math.floor(GetLocal().pos.x /32).."|\ny|"..math.floor(GetLocal().pos.y /32).."\nbuyamount|250")
        Sleep(400)
    end

end

local function CVDL()
    if EVADE_TAXES then
        if GetPlayerInfo().gems >= 100000 then
            SendPacket(2,"action|dialog_return\ndialog_name|telephone\nnum|53785|\nx|"..TELEPHONE_X.."|\ny|"..TELEPHONE_Y.."|\nbuttonClicked|dlconvert")
            Sleep(200)
        end
    
        if GetItemCount(1796) >= 100 then
            SendPacket(2,"action|dialog_return\ndialog_name|telephone\nnum|53785|\nx|"..TELEPHONE_X.."|\ny|"..TELEPHONE_Y.."|\nbuttonClicked|bglconvert")
            Sleep(200)
        end
        if GetItemCount(7188) >= 100 then
            SendPacket(2, "action|dialog_return\ndialog_name|info_box\nbuttonClicked|make_bgl")
            Sleep(200)
        end
    end
end

-- Main loop
while true do
    dropbgems()
    buybgems()
    eatbgems()
    CVDL()
end
