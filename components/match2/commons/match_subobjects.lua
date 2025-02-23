---
-- @Liquipedia
-- wiki=commons
-- page=Module:Match/Subobjects
--
-- Please see https://github.com/Liquipedia/Lua-Modules to contribute
--

local Json = require('Module:Json')
local Logic = require('Module:Logic')
local String = require('Module:StringUtils')
local Table = require('Module:Table')
local getArgs = require('Module:Arguments').getArgs
local wikiSpec = require('Module:Brkts/WikiSpecific')

local ALLOWED_OPPONENT_TYPES = { 'literal', 'team', 'solo', 'duo', 'trio', 'quad' }

local MatchSubobjects = {}

function MatchSubobjects.getOpponent(frame)
	local args = getArgs(frame)
	return MatchSubobjects.luaGetOpponent(frame, args)
end

function MatchSubobjects.luaGetOpponent(frame, args)
	if not Table.includes(ALLOWED_OPPONENT_TYPES, args.type) then
		error('Unknown opponent type ' .. args.type)
	end

	args = wikiSpec.processOpponent(frame, args)
	return Json.stringify({
		extradata = args.extradata,
		icon = args.icon,
		match2players = args.players or args.match2players,
		name = args.name,
		score = args.score,
		template = args.template,
		type = args.type,
		-- other variables such as placement and status are set from Module:MatchGroup
	})
end

function MatchSubobjects.getMap(frame)
	local args = getArgs(frame)
	return MatchSubobjects.luaGetMap(frame, args)
end

function MatchSubobjects.luaGetMap(frame, args)
	-- dont save map if 'map' is not filled in
	if Logic.isEmpty(args.map) then
		return nil
	else
		args = wikiSpec.processMap(frame, args)

		local participants = args.participants or {}
		if type(participants) == 'string' then
			participants = Json.parse(participants)
		end
		for key, item in pairs(participants) do
			if not key:match('%d_%d') then
				error('Key \'' .. key .. '\' in match2game.participants has invalid format: \'<number>_<number>\' expected')
			elseif type(item) == 'string' and String.startsWith(item, '{') then
				participants[key] = Json.parse(item)
			elseif type(item) ~= 'table' then
				error('Item \'' .. tostring(item) .. '\' in match2game.participants has invalid format: table expected')
			end
		end
		args.participants = participants

		return Json.stringify({
			date = args.date,
			extradata = args.extradata,
			game = args.game,
			length = args.length,
			map = args.map,
			mode = args.mode,
			participants = args.participants,
			resulttype = args.resulttype,
			rounds = args.rounds,
			scores = args.scores,
			subgroup = args.subgroup,
			type = args.type,
			vod = args.vod,
			walkover = args.walkover,
			winner = args.winner,
		})
	end
end

function MatchSubobjects.getRound(frame)
	local args = getArgs(frame)
	return MatchSubobjects.luaGetRound(frame, args)
end

function MatchSubobjects.luaGetRound(frame, args)
	return Json.stringify(args)
end

function MatchSubobjects.getPlayer(frame)
	local args = getArgs(frame)
	return MatchSubobjects.luaGetPlayer(frame, args)
end

function MatchSubobjects.luaGetPlayer(frame, args)
	args = wikiSpec.processPlayer(frame, args)
	return Json.stringify({
		displayname = args.displayname,
		extradata = args.extradata,
		flag = args.flag,
		name = args.name,
	})
end

return MatchSubobjects
