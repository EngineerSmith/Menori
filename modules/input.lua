--[[
-------------------------------------------------------------------------------
	Menori
	@author rozenmad
	2020
-------------------------------------------------------------------------------
--]]

--- Input manager.
-- @module Input
local button_list = {}

local Input = {}

--- Button constants.
Input.button = {
	A = 'z', -- kp1
	B = 'x', -- kp2
	W_arrow = 'w', -- w
	A_arrow = 'a', -- a
	S_arrow = 's', -- s
	D_arrow = 'd', -- d
}


--- Check keyboard button is down.
Input.keyboard_is_down = function(button, press_repeat)
	if press_repeat == nil then press_repeat = true end

	local state = love.keyboard.isDown(button)
	if press_repeat then return state end

	if state and button_list[button] then return false end
	button_list[button] = state
	return state
end

--- Button A
Input.key_a = function(press_repeat)
	return Input.keyboard_is_down(Input.button.A, press_repeat)
end
--- Button B
Input.key_b = function(press_repeat)
	return Input.keyboard_is_down(Input.button.B, press_repeat)
end

--- Button Move W
Input.key_move_w = function(press_repeat)
	return Input.keyboard_is_down(Input.button.W_arrow, press_repeat)
end
--- Button Move A
Input.key_move_a = function(press_repeat)
	return Input.keyboard_is_down(Input.button.A_arrow, press_repeat)
end
--- Button Move S
Input.key_move_s = function(press_repeat)
	return Input.keyboard_is_down(Input.button.S_arrow, press_repeat)
end
--- Button Move D
Input.key_move_d = function(press_repeat)
	return Input.keyboard_is_down(Input.button.D_arrow, press_repeat)
end

--- Button Space
Input.key_space = function(press_repeat)
	return Input.keyboard_is_down('c', press_repeat)
end

return Input