/**
 * @file main.nut
 * @author [VU]Xmair
 * @desc Demo
 */

decUIEnabled <- true;

function Script::ScriptLoad() {
	Script.LoadScript("XAnimations/XAnimations_Main.nut");

	local
		showOpenDemo = true,
		showCloseDemo = false,
		showFadeInDemo = true,
		showFadeOutDemo = false,
		decUIShowOpenDemo = false,
		decUIShowCloseDemo = false;

	if (decUIEnabled) {
		Script.LoadScript("decui/decui.nut");
		if (decUIShowOpenDemo) {
			UI.Canvas({
				id = "canv_1",
				Size = VectorScreen(0, 5),
				Position = VectorScreen(GUI.GetScreenSize().X / 2 - 320, GUI.GetScreenSize().Y / 2 - 240),
				Color = Colour(176, 176, 176, 100)
			});

			local animationInfo =
			{
				size = VectorScreen(640, 480),
				sizeIncrement = VectorScreen(8.5, 5),
				onFinish = function(elementAnimationType, elementAnimationInfo) {
					Console.Print("Element has finished playing animation.");
				}
			};

			SqAnimations.addElement("canv_1", SqAnimationType.OPEN, animationInfo, SqAnimationElement.decUICanvas);
		}

		if (decUIShowCloseDemo) {
			UI.Canvas({
				id = "canv_2",
				Size = VectorScreen(640, 480),
				Position = VectorScreen(GUI.GetScreenSize().X / 2 - 320, GUI.GetScreenSize().Y / 2 - 240),
				Color = Colour(176, 176, 176, 100)
			});

			local animationInfo =
			{
				size = VectorScreen(0, 5),
				sizeDecrement = VectorScreen(8.5, 5),
				onFinish = function(elementAnimationType, elementAnimationInfo) {
					Console.Print("Element has finished playing animation.");
				}
			};

			SqAnimations.addElement("canv_2", SqAnimationType.CLOSE, animationInfo, SqAnimationElement.decUICanvas);
		}
	}
	
	if (showOpenDemo) {
		local animationInfo =
		{
			size = VectorScreen(640, 480),
			sizeIncrement = VectorScreen(8.5, 5),
			onFinish = function(elementAnimationType, elementAnimationInfo) {
				Console.Print("Element has finished playing animation.");
			}
		};

		canvas <- GUICanvas();
		canvas.Size = VectorScreen(0, 0);
		canvas.Position = VectorScreen(GUI.GetScreenSize().X / 2 - 320, GUI.GetScreenSize().Y / 2 - 240);
		canvas.Color = Colour(176, 176, 176, 100);

		SqAnimations.addElement(canvas, SqAnimationType.OPEN, animationInfo);
	}

	if (showCloseDemo) {
		local animationInfo =
		{
			size = VectorScreen(0, 5),
			sizeDecrement = VectorScreen(8.5, 5),
			onFinish = function(elementAnimationType, elementAnimationInfo) {
				Console.Print("Element has finished playing animation.");
			}
		};

		canvas1 <- GUICanvas();
		canvas1.Size = VectorScreen(640, 480);
		canvas1.Position = VectorScreen(GUI.GetScreenSize().X / 2 - 320, GUI.GetScreenSize().Y / 2 - 240);
		canvas1.Color = Colour(176, 176, 176, 100);

		SqAnimations.addElement(canvas1, SqAnimationType.CLOSE, animationInfo);
	}

	if (showFadeInDemo) {
		local animationInfo =
		{
			maxAlpha = 255,
			alphaIncrement = 1,
			onFinish = function(elementAnimationType, elementAnimationInfo) {
				Console.Print("Element has finished playing animation.");
			}
		};

		canvas2 <- GUICanvas();
		canvas2.Size = VectorScreen(640, 480);
		canvas2.Position = VectorScreen(GUI.GetScreenSize().X / 2 - 320, GUI.GetScreenSize().Y / 2 - 240);
		canvas2.Color = Colour(176, 176, 176, 0);

		SqAnimations.addElement(canvas2, SqAnimationType.FADE_IN, animationInfo);
	}

	if (showFadeOutDemo) {
		local animationInfo =
		{
			minAlpha = 0,
			alphaDecrement = 1,
			onFinish = function(elementAnimationType, elementAnimationInfo) {
				Console.Print("Element has finished playing animation.");
			}
		};

		canvas3 <- GUICanvas();
		canvas3.Size = VectorScreen(640, 480);
		canvas3.Position = VectorScreen(GUI.GetScreenSize().X / 2 - 320, GUI.GetScreenSize().Y / 2 - 240);
		canvas3.Color = Colour(176, 176, 176, 255);

		SqAnimations.addElement(canvas3, SqAnimationType.FADE_OUT, animationInfo);
	}
}

function Script::ScriptProcess() {
	if (decUIEnabled) {
		UI.events.scriptProcess();
	}

	SqAnimations.onProcess();
}