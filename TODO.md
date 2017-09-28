Make missions a plugin-style folder structure.
Missions can have their own roles

Separate namespace for game plugins/modules? Can distribute code and config file in one structure.

TODO: visited properties in locations. Save them!
TODO: Score!

ACTIONS: talk, look, attack, unlock, light, take, move, open, block

Goals:
- Easy for non-techies to make content for
- Easy to run and play
- Few dependencies as possible
- Get a little out of my comfort zone (YAML, Mojo)

Needs:
- more testing
- more validation

Expansion ideas:
- Multiplayer? (multiple people playing single-player games)
- Chat?
- Multiple things per location
- Deployment
- Media in game folder
- AJAX-y client
- All-in-one client and game in Electron
- Actions are not very efficient. 

Add docs for mission building.

Tests:
- location: ancestor
- player: reset
- adventure: score(), have actions
- set_player()
- valid mission
- invalid mission. Then test for everything wrong with it.
- no duplicate slugs
- everything has a default state
- Test that exit roles return exits (?)
- location: make sure ancestor and my set_state work

Engine: 
- in single player games, doesn't do much
- Will do more for multiplayer.

Player: 
- Part of game, not mission.
- Needed for an eventual multiplayer engine.
- But.... how does mission alter player?
- Ran into this problem, need to pass player handle to mission.

in move game action, copy adventure actions into room when moving

move = run = walk = go. Set visited property

Talk: 
- This is an example of when a good idea goes bad :) "It's a simple game - how long can it take?!?"
- Didn't take long to make a base Thing
- Immutable actors, or complex definition? Neither - state!
- Boilerplate validation: how I fixed.
- Import::Base
- Could have used roles. Future iteration!
- Lions and tigers and circular references, oh my!

Items, actors, locations:
made this arrayrefs at first
and then I realized I'd actually have to use them ;)
and so I turned them to hashrefs
