Make missions a plugin-style folder structure.
Missions can have their own roles

Separate namespace for game plugins/modules? Can distribute code and config file in one structure.

TODO: visited properties in locations. Save them!
TODO: Score!

ACTIONS: talk, look, attack, unlock, light, take, move, open, block

Needs:
- more testing
- more validation

Expansion ideas:
- Multiplayer? (multiple people playing single-player games)
- Chat?
- Multiple things per location (2x guards)
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

in move game action, copy adventure actions into room when moving

