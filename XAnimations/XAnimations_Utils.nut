/**
 * @file XAnimations_Utils.nut
 * @author [VU]Xmair
 */

SqAnimationElement <- {
    decUICanvas = "UI.Canvas",
    decUISprite = "UI.Sprite",
    decUIButton = "UI.Button",
    decUIProgressBar = "UI.ProgressBar",
    decUICircle = "UI.Circle",
    decUICheckbox = "UI.CheckBox",
    decUIEditbox = "UI.EditBox", 
    decUIListbox = "UI.Listbox",
    decUIMemobox = "UI.Memobox",
    decUIWindow = "UI.Window",
	decUILabel = "UI.Label",
	decUIScrollbar = "UI.Scrollbar"
}

enum _SqAnimationType {
    OPEN,
    CLOSE,
    FADE_IN,
    FADE_OUT
}

SqAnimationType <- getconsttable().rawget("_SqAnimationType");