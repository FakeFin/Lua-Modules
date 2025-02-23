---
-- @Liquipedia
-- wiki=commons
-- page=Module:Brkts/WikiSpecific/Base
--
-- Please see https://github.com/Liquipedia/Lua-Modules to contribute
--

local FnUtil = require('Module:FnUtil')
local Lua = require('Module:Lua')

local WikiSpecificBase = {}

-- called from Module:MatchGroup
-- called after processMap/processOpponent/processPlayer
-- used to alter match related parameters, e.g. automatically setting the winner
-- @returns the match after changes have been applied
function WikiSpecificBase.processMatch(frame, match)
	error("This function needs to be implemented on your wiki")
end

-- called from Module:Match/Subobjects
-- used to transform wiki-specific input of templates to the generalized
-- format that is required by Module:MatchGroup
-- @returns the map after changes have been applied
function WikiSpecificBase.processMap(frame, map)
	error("This function needs to be implemented on your wiki")
end

-- called from Module:Match/Subobjects
-- used to transform wiki-specific input of templates to the generalized
-- format that is required by Module:MatchGroup
-- @returns the opponent after changes have been applied
function WikiSpecificBase.processOpponent(frame, opponent)
	error("This function needs to be implemented on your wiki")
end

-- called from Module:Match/Subobjects
-- used to transform wiki-specific input of templates to the generalized
-- format that is required by Module:MatchGroup
-- @returns the player after changes have been applied
function WikiSpecificBase.processPlayer(frame, player)
	error("This function needs to be implemented on your wiki")
end

--[[
Converts a match record to a structurally typed table with the appropriate data
types for field values. The match record is either a match created in the store
bracket codepath (WikiSpecific.processMatch), or a record fetched from LPDB
(MatchGroupUtil.fetchMatchRecords).

Called from MatchGroup/Util

-- @returns match
]]
WikiSpecificBase.matchFromRecord = FnUtil.lazilyDefineFunction(function()
	return require('Module:MatchGroup/Util').matchFromRecord
end)

--[[
Returns the module for the matchlist or bracket display modules. The returned
module must have a luaGet method.

To customize matchlists and brackets for a wiki, override this to return
display modules with the wiki-specific customizations.

Called from MatchGroup/Display

-- @returns module
]]
WikiSpecificBase.getMatchGroupModule = function(matchGroupType)
	return matchGroupType == 'matchlist'
		and Lua.import('Module:MatchGroup/Display/Matchlist', {requireDevIfEnabled = true})
		or Lua.import('Module:MatchGroup/Display/Bracket', {requireDevIfEnabled = true})
end

return WikiSpecificBase
