# XAnimations
Client side library for animations made for VC:MP. Supports decUI elements as well as the default elements.

# Installation
1. Click the "Clone or download" button, select "Download ZIP".
2. Extract all the "XAnimations-master/XAnimations" folder to "store/script/..here"
3. Add the following code into your script:

```Squirrel
function Script::ScriptLoad() {
  Script.LoadScript("XAnimations/XAnimations_Main.nut");
}

function Script::ScriptProcess() {
  SqAnimations.onProcess();
}
```

# Usage
Refer to the [Wiki](https://github.com/Xmair/XAnimations/wiki).

# Credits
- Xmair
- Doom_Kill3R (DizzasTeR)
