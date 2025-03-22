-- WeeklyReset.lua

local frame = CreateFrame("Frame", "WeeklyResetFrame", UIParent)
frame:SetSize(200, 50)
frame:SetPoint("CENTER")
frame:EnableMouse(true)
frame:SetMovable(true)
frame:RegisterForDrag("LeftButton")
frame:SetScript("OnDragStart", frame.StartMoving)
frame:SetScript("OnDragStop", frame.StopMovingOrSizing)

local text = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
text:SetAllPoints()
text:SetJustifyH("CENTER")

local function GetWeeklyResetTime()
    local currentTime = time()
    local dateTable = date("*t", currentTime)

    -- Weekly reset happens on Tuesday at 8:00 AM server time (adjust as needed)
    local resetDay = 3 -- 3 = Tuesday (1 = Sunday, 2 = Monday, etc.)
    local resetHour = 8
    local resetMinute = 0

    -- Calculate the time for the next reset
    local daysUntilReset = (resetDay - dateTable.wday + 7) % 7
    if daysUntilReset == 0 and (dateTable.hour > resetHour or (dateTable.hour == resetHour and dateTable.min >= resetMinute)) then
        daysUntilReset = 7
    end

    local resetTime = time({
        year = dateTable.year,
        month = dateTable.month,
        day = dateTable.day + daysUntilReset,
        hour = resetHour,
        min = resetMinute,
        sec = 0
    })

    return resetTime
end

local function UpdateCountdown()
    local resetTime = GetWeeklyResetTime()
    local currentTime = time()
    local timeLeft = resetTime - currentTime

    if timeLeft > 0 then
        local days = math.floor(timeLeft / (24 * 60 * 60))
        local hours = math.floor((timeLeft % (24 * 60 * 60)) / (60 * 60))
        local minutes = math.floor((timeLeft % (60 * 60)) / 60)
        local seconds = timeLeft % 60

        text:SetText(string.format("Weekly Reset in: %d days, %02d:%02d:%02d", days, hours, minutes, seconds))
    else
        text:SetText("Weekly Reset has occurred!")
    end
end

frame:SetScript("OnUpdate", UpdateCountdown)
UpdateCountdown()