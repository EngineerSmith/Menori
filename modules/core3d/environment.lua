--[[
-------------------------------------------------------------------------------
	Menori
	@author rozenmad
	2020
-------------------------------------------------------------------------------
--]]

--- An Environment contains the uniform values specific for a location. For example, the lights are part of the Environment.
local class = require 'menori.modules.libs.class'
local ml 	= require 'menori.modules.ml'

local vec3 = ml.vec3

local Environment = class('Environment')

local directional_light = class('DirectionalLight')

function directional_light:constructor(dx, dy, dz, color)
	self.direction = vec3(dx, dy, dz):normalize()
	self.color = color
	self.type = 1
	self.enabled = true
end

function directional_light:to_uniforms(shader, light_index_str)
	if self.enabled then
		shader:send(light_index_str .. 'direction', {self.direction:unpack()})
		shader:send(light_index_str .. 'color', self.color)
		shader:send(light_index_str .. 'type', self.type)
	else
		shader:send(light_index_str .. 'type', 0)
	end
end

local point_light = class('PointLight')

function point_light:constructor(x, y, z, color, power, distance)
	self.position = vec3(x, y, z)
	self.color = color
	self.power = power
	self.distance = distance
	self.type = 2
	self.enabled = true
end

function point_light:to_uniforms(shader, light_index_str)
	if self.enabled then
		shader:send(light_index_str .. 'position', {self.position:unpack()})
		shader:send(light_index_str .. 'color', self.color)
		shader:send(light_index_str .. 'distance', self.distance)
		shader:send(light_index_str .. 'power', self.power)
		shader:send(light_index_str .. 'type', self.type)
	else
		shader:send(light_index_str .. 'type', 0)
	end
end

--- Constructor
function Environment:constructor(camera)
	self.camera = camera

	self.uniform_table = {
		fog_color = {love.math.colorFromBytes(0, 0, 0, 255)},
		fog_density = 0.05,
		fog_indent = 0.0,
		ambient_color = {1.0, 1.0, 1.0}
	}

	self.lights = {}
	self.shader = Environment.default_shader
end

function Environment:set_optional_uniform(name, value)
	self.uniform_table[name] = value
end

function Environment:add_direction_light(...)
	self.lights[#self.lights + 1] = directional_light(...)
end

function Environment:add_point_light(...)
	self.lights[#self.lights + 1] = point_light(...)
end

function Environment:add_light(light)
	self.lights[#self.lights + 1] = light
end

--- Set fog color
function Environment:set_fog_color(r, g, b, a)
	self.uniform_table.fog_color = {r, g, b, a}
end

function Environment:send_uniforms_to(shader)
	local camera = self.camera
	shader:send_matrix("m_view", camera.m_view)
	shader:send_matrix("m_projection", camera.m_projection)

	for k, v in pairs(self.uniform_table) do
		shader:send(k, v)
	end

	self:send_light_sources_to(shader)
end

function Environment:send_light_sources_to(shader)
	shader:send('light_count', #self.lights)
	for i = 1, #self.lights do
		local light = self.lights[i]
		local light_index_str =  "lights[" .. (i - 1) .. "]."
		light:to_uniforms(shader, light_index_str)
	end
end

return
Environment