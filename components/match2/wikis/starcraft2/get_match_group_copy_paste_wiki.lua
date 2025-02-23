---
-- @Liquipedia
-- wiki=starcraft2
-- page=Module:GetMatchGroupCopyPaste/wiki
--
-- Please see https://github.com/Liquipedia/Lua-Modules to contribute
--

--[[

WikiSpecific Code for MatchList and Bracket Code Generators

]]--

local wikiCopyPaste = {}

--allowed opponent types on the wiki (archon and 2v2 both are of type
--"duo", but they need different code, hence them both being available here)
local MODES = {
	['1v1'] = '1v1',
	['2v2'] = '2v2',
	['3v3'] = '3v3',
	['4v4'] = '4v4',
	['archon'] = 'archon',
	['team'] = 'team',
	['literal'] = 'literal',
	['1'] = '1v1',
	['2'] = '2v2',
	['3'] = '3v3',
	['4'] = '4v4'
	}

--default opponent type (used if the entered mode is not found in the above table)
local DefaultMode = '1v1'

--returns the cleaned opponent type
function wikiCopyPaste.getMode(mode)
	return MODES[string.lower(mode or '')] or DefaultMode
end

--returns the Code for a Match, depending on the input
function wikiCopyPaste.getMatchCode(bestof, mode, index, opponents, args)
	if bestof == 0 and args.score ~= 'false' then
		args.score = 'true'
	end
	local score = args.score == 'true' and '|score=' or ''
	local hasDate = args.hasDate == 'true' and '\n\t|date=\n\t|twitch=' or ''
	local needsWinner = args.needsWinner == 'true' and '\n\t|winner=' or ''
	local out = '{{Match' .. (index == 1 and ('|bestof=' .. (bestof ~= 0 and bestof or '')) or '') ..
		needsWinner .. hasDate

	for i = 1, opponents do
		out = out .. '\n\t|opponent' .. i .. '=' .. wikiCopyPaste._getOpponent(mode, score)
	end

	if bestof ~= 0 then
		if mode == 'team' and tonumber(args.submatch or '') then
			local submatchBo = tonumber(args.submatch)
			for i = 1, bestof do
				local submatchNumber = math.floor((i-1)/submatchBo) + 1
				out = out .. '\n\t|map' .. i .. '={{Map|map=|winner=|t1p1=|t2p1=|subgroup=' .. submatchNumber .. '}}'
			end
		elseif mode == 'team' and args.submatch == 'true' then
			for i = 1, bestof do
				out = out .. '\n\t|map' .. i .. '={{Map|map=|winner=|t1p1=|t2p1=|subgroup=}}'
			end
		elseif mode == 'team' then
			for i = 1, bestof do
				out = out .. '\n\t|map' .. i .. '={{Map|map=|winner=|t1p1=|t2p1=}}'
			end
		else
			for i = 1, bestof do
				out = out .. '\n\t|map' .. i .. '={{Map|map=|winner=}}'
			end
		end
	end

	return out .. '\n\t}}'
end

--subfunction used to generate the code for the Opponent template, depending on the type of opponent
function wikiCopyPaste._getOpponent(mode, score)
	local out

	if mode == '1v1' then
		out = '{{1v1Opponent|p1=' .. score .. '}}'
	elseif mode == '2v2' then
		out = '{{2v2Opponent|p1=|p2=' .. score .. '}}'
	elseif mode == '3v3' then
		out = '{{3v3Opponent|p1=|p2=|p3=' .. score .. '}}'
	elseif mode == '4v4' then
		out = '{{4v4Opponent|p1=|p2=|p3=|p4=' .. score .. '}}'
	elseif mode == 'archon' then
		out = '{{Archon|p1=|p2=|race=' .. score .. '}}'
	elseif mode == 'team' then
		out = '{{TeamOpponent|template=' .. score .. '}}'
	elseif mode == 'literal' then
		out = '{{Literal|}}'
	end

	return out
end

--function that sets the text that starts the invoke of the MatchGroup Moduiles,
--contains madatory stuff like bracketid, templateid and MatchGroup type (matchlist or bracket)
--on sc2 also used to link to the documentation pages about the new bracket/match system
function wikiCopyPaste.getStart(template, id, modus, args)
	local tooltip = args.tooltip == 'true' and ('\n' .. mw.text.nowiki('<!--') ..
		' For more information on Bracket parameters see Liquipedia:Brackets ' ..
		mw.text.nowiki('-->') .. '\n' .. mw.text.nowiki('<!--') ..
		' For Opponent Copy-Paste-Code see Liquipedia:Brackets/Opponents#Copy-Paste ' ..
		mw.text.nowiki('-->')) or ''
	return '{{' .. (modus == 'bracket' and
		('Bracket|Bracket/' .. template) or 'Matchlist') ..
		'|id=' .. id .. tooltip
end

return wikiCopyPaste
