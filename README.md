DU Resource Panel
-----------------

This DU Resource Panel LUA script will display all T1 and T2; Ores, Refined, Products, Intermediary Part, and Complex Parts.

It doesn't require linking any containers to the programming board,  
instead you link the static core to the board and set the name of the containers to what their content holds.  

Unforuntately it's not actually possible to check what is inside a container, so the containers must only hold 1 thing.  
This means you need to use transfer units to move side products, such as Pure Oxygen and Hydrogen out of the containers. Same for the T1 refined ores which are a side product of refining T2s.


### How to use
1) Goto the releases page: https://github.com/rubensayshi/du-resource-panel/releases
2) Open the `du-resource-panel.json` file, copy the contents (CTRL+A -> CTRL+C).
3) Now right click ingame on your programming board, Advanced -> Import from cliboard.
4) Now activate the programming board, by hitting F, you'll need do this every time you've been offline or just out of range.



### Building the project
If you want to make code changes and compile it into the importable JSON, you'll need the latest version of: https://github.com/rubensayshi/duconverter 

If I haven't been too lazy you should be able to download those from the releases page, 
otherwise you might have to `go install github.com/rubensayshi/duconverter/src/cmd/dujsonexporter`.

Then you can simply run: `dujsonexporter src export.json`, or if you have `reflex` you can even do the following to rebuild on code changes:
```
reflex -s -r 'src/.*.lua$$' -R 'tmp/' -R '*.json' -- sh -c 'dujsonexporter src export.json'
```
