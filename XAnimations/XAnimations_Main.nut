/**
 * @file XAnimations_Main.nut
 * @author [VU]Xmair
 */
 
// Load the required files
{
	local
		dir = "XAnimations/",
		ext = ".nut",
		files = ["XAnimations_Utils", "XAnimations_Info"];
	
	foreach(file in files) {
		Script.LoadScript(format("%s%s%s", dir, file, ext));
	}
}

// Attach custom properties to the elements
{
	/**
	 * @desc Attach custom properties to existing GUIElements
	 * @params
	   * @required [properties|array]: An array containing custom properties to be attached
	   
	 * @returns [null]
	 */
	local function attachProperties(properties) {
		foreach(property in properties) { 
			foreach(element in [GUIButton, GUICanvas, GUICheckbox, GUIEditbox, GUILabel, GUIListbox, GUIMemobox, GUIProgressBar, GUIScrollbar, GUISprite, GUIWindow]) { 
				element.rawnewmember(property, null);
			}
		}
	}
	
	attachProperties(["onAnimationFinish"]);
}

class SqAnimations {
	/**
	 * @desc Array to hold the element data
	 */
    static ELEMENTS = [];
	
	/**
	 * @desc Add an element for animation processing
	 * @params
	   * @required [element|string/GUIElement]: string in case of decUI element, GUIElement otherwise
	   * @required [elementAnimationType|integer]: any animation type from SqAnimationType
	   * @required [elementAnimationInfo|table]: animation info
	   * @optional [elementType|string]: only required if the element is a decUI element
	   
	 * @returns [null]
	 */
    static function addElement(element, elementAnimationType, elementAnimationInfo, elementType = null) {
		// Checking if we have a custom [onFinish] event
		if (elementAnimationInfo.rawin("onFinish") && typeof(elementAnimationInfo.onFinish) == "function") {
			// If we element specified was a GUIElement
			if (element instanceof GUIElement) {
				// We set the element's custom event to the one the user has specified
				element.onAnimationFinish = elementAnimationInfo.onFinish;
			}
			else {
				// In case of the element being a decUI element,
				// we search for the element using decUI's methods.
				
				// The reason I'm storing decUI elements as strings is that
				// decUI already stores all of it's elements in an array, so it is
				// best to just copy the id of the element instead of creating more copies of the
				// actual element.
				
				local
					decUIElement = compilestring(format("return %s(\"%s\")", elementType, element))();
				
				// We set the element's custom event to the one the user has specified
				decUIElement.onAnimationFinish = elementAnimationInfo.onFinish;
			}
		}
		
		// Finally pushing the information we have received from the user
		// into our elements array
		SqAnimations.ELEMENTS.push(SqAnimationInfo(element, elementType, elementAnimationType, elementAnimationInfo));
    }
	
	/**
	 * @desc Check if an element has animations being applied
	 * @params
	   * @required [element|string/GUIElement]: string in case of decUI element, GUIElement otherwise
	   
	 * @returns [boolean]: true if element exists, false if not
	 */
    static function hasElement(e) {
		// Check if our element array is empty
		if (SqAnimations.ELEMENTS.len() == 0) {
			// No elements were found
			return false;
		}
	
		// Search our elements array
		foreach(idx, element in SqAnimations.ELEMENTS) {
			if (element.getElement() == e) {
				// We found the element
				return true;
			}
		}
		
		// No elements were found
		return false;
    }
	
	/**
	 * @desc Remove an element from animation processing
	 * @params
	   * @required [element|string/GUIElement]: string in case of decUI element, GUIElement otherwise
	   
	 * @returns [null]
	 */
    static function removeElement(e) {
        // Check if our element array is empty
		if (SqAnimations.ELEMENTS.len() == 0) {
			// No elements were found, so we throw an error
			throw("Invalid element specified");
		}
	
		// Search our elements array
		foreach(idx, element in SqAnimations.ELEMENTS) {
			// The ternary operator is checking if the element
			// has an [id] member, i.e., to check if it is a
			// decUI element
			if (element.getElement() == ("id" in e ? (e.id == null ? e : e.id) : e)) {
				// We found the element so we remove it
				SqAnimations.ELEMENTS.remove(idx);
				return;
			}
		}
		
		// No elements were found, so we throw an error
		throw("Invalid element specified");
    }
	
	/**
	 * @desc Animation processing function
	 * @returns [null]
	 */
    static function onProcess() {
		// Loop through all of our elements
        for(local i = 0; i < SqAnimations.ELEMENTS.len(); i ++) {
			// Put the data of the animation into variables
            local
                element = SqAnimations.ELEMENTS[i].getElement(true),
                elementType = SqAnimations.ELEMENTS[i].getElementType(),
                elementAnimationType = SqAnimations.ELEMENTS[i].getElementAnimationType(),
                elementAnimationInfo = SqAnimations.ELEMENTS[i].getElementAnimationInfo();
			
			// Check for the animation type
            switch(elementAnimationType) {
                case SqAnimationType.OPEN: {
					// If the element's X size is less than the maximum specified
                    if (element.Size.X < elementAnimationInfo.size.X) {
						// If we add the size into the current size,
						// does it become more than the maximum size specified by
						// the user?
                        if (element.Size.X + elementAnimationInfo.sizeIncrement.X > elementAnimationInfo.size.X) {
							// If so, we set the element's size to the
							// maximum size specified by the user
                            element.Size.X = elementAnimationInfo.size.X;
						}
                        else {
							// If not, we simply add to the size
                            element.Size.X += elementAnimationInfo.sizeIncrement.X;
						}
                    }
					// If the element's Y size is less than the maximum specified
                    else if (element.Size.Y < elementAnimationInfo.size.Y) {
						// If we add the size into the current size,
						// does it become more than the maximum size specified by
						// the user?
                        if (element.Size.Y + elementAnimationInfo.sizeIncrement.Y > elementAnimationInfo.size.Y) {
							// If so, we set the element's size to the
							// maximum size specified by the user
                            element.Size.Y = elementAnimationInfo.size.Y;
						}
                        else {
							// If not, we simply add to the size
                            element.Size.Y += elementAnimationInfo.sizeIncrement.Y;
						}
                    }
                    else {
						// The animation has completed, so we remove the
						// element from our array and call the [onFinish] function
                        SqAnimations.removeElement(element);
                        SqAnimations.innerEvent_onFinish(element, elementAnimationType, elementAnimationInfo);
                    }
                }
                    break;

                case SqAnimationType.CLOSE: {
					// If the element's X size is greater than the minimum specified
                    if (element.Size.Y > elementAnimationInfo.size.Y) {
						// If we subtract the size from the current size,
						// does it become more than the minimum size specified by
						// the user?
                        if (element.Size.Y - elementAnimationInfo.sizeDecrement.Y < elementAnimationInfo.size.Y) {
							// If so, we set the element's size to the
							// minimum size specified by the user
                            element.Size.Y = elementAnimationInfo.size.Y;
						}
                        else {
							// If not, we simply subtract from the size
                            element.Size.Y -= elementAnimationInfo.sizeDecrement.Y;
						}
                    }
					// If the element's Y size is greater than the minimum specified
                    else if (element.Size.X > elementAnimationInfo.size.X) {
						// If we subtract the size from the current size,
						// does it become more than the minimum size specified by
						// the user?
                        if (element.Size.X - elementAnimationInfo.sizeDecrement.X < elementAnimationInfo.size.X) {
							// If so, we set the element's size to the
							// minimum size specified by the user
                            element.Size.X = elementAnimationInfo.size.X;
						}
                        else {
							// If not, we simply subtract from the size
                            element.Size.X -= elementAnimationInfo.sizeDecrement.X;
						}
                    }
                    else {
						// The animation has completed, so we remove the
						// element from our array and call the [onFinish] function
                        SqAnimations.removeElement(element);
                        SqAnimations.innerEvent_onFinish(element, elementAnimationType, elementAnimationInfo);
                    }
                }
                    break;
					
				case SqAnimationType.FADE_IN: {
					// If the element's alpha is less than the maximum specified
					if (element.Alpha < elementAnimationInfo.maxAlpha) {
						// If we add the alpha specified by the user
						// into the current alpha, does it become more
						// than the maximum alpha specified by the user?
						if (element.Alpha + elementAnimationInfo.alphaIncrement > elementAnimationInfo.maxAlpha) {
							// If so, we set the element's alpha to the
							// maximum alpha specified by the user
							element.Alpha = elementAnimationInfo.maxAlpha;
						}
						else {
							// If not, we simply add to the alpha
							element.Alpha += elementAnimationInfo.alphaIncrement;
						}
					}
					else {
						// The animation has completed, so we remove the
						// element from our array and call the [onFinish] function
						SqAnimations.removeElement(element);
                        SqAnimations.innerEvent_onFinish(element, elementAnimationType, elementAnimationInfo);
					}
				}
					break;
					
				case SqAnimationType.FADE_OUT: {
					// If the element's alpha is greater than the minimum specified
					if (element.Alpha > elementAnimationInfo.minAlpha) {
						// If we subtract the alpha specified by the user
						// from the current alpha, does it become less
						// than the mainimum alpha specified by the user?
						if (element.Alpha - elementAnimationInfo.alphaDecrement < elementAnimationInfo.minAlpha) {
							// If so, we set the element's alpha to the
							// minimum alpha specified by the user
							element.Alpha = elementAnimationInfo.minAlpha;
						}
						else {
							// If not, we simply subtract from the alpha
							element.Alpha -= elementAnimationInfo.alphaDecrement;
						}
					}
					else {
						// The animation has completed, so we remove the
						// element from our array and call the [onFinish] function
						SqAnimations.removeElement(element);
                        SqAnimations.innerEvent_onFinish(element, elementAnimationType, elementAnimationInfo);
					}
				}
					break;
					
				default: {
					// An invalid animation was specified,
					// so we remove the animation and throw
					// an error
					SqAnimations.removeElement(element);
					throw("Invalid animation type");
				}
					break;
            }
        }
    }
	
	/**
	 * @desc Inner event that is called when an animation is finished
	 * @params
	   * @required [element|GUIElement]: element instance
	   * @required [elementAnimationType|integer]: animation type from the SqAnimationType enumeration
	   * @required [elementAnimationInfo|table]: animation info
	   
	 * @returns [null]
	 */
    static function innerEvent_onFinish(element, elementAnimationType, elementAnimationInfo) {
		// Check if our element has a custom function specified
        if (element.rawin("onAnimationFinish") && typeof(element.onAnimationFinish) == "function") {
			// It does, so we call it
            element.onAnimationFinish(elementAnimationType, elementAnimationInfo);
		}
    }
};