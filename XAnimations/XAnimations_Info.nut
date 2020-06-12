/**
 * @file XAnimations_Info.nut
 * @author [VU]Xmair
 */

class SqAnimationInfo {
	element = null;
	elementType = null;
	elementAnimationType = null;
	elementAnimationInfo = null;
	
	/** 
	  * @params
		* @required [e|string/instance]: string in case of decUI element, instance otherwise
		* @required [eType|string/null]: element type
		* @required [eAnimationType|integer]: animation type
		* @required [eAnimationInfo|table]: animation info
	  * @returns [SqAnimationInfo] object
	 */
	constructor(e, eType, eAnimationType, eAnimationInfo) {
		this.element = e;
		this.elementType = eType;
		this.elementAnimationType = eAnimationType;
		this.elementAnimationInfo = eAnimationInfo;
	}
	
	/**
	 * @desc Getter methods
	 */
	
	/**
	 * @params
	   * @optional [inst|boolean]: searches for a decUI element if true
	   
	 * @returns [instance/string]: element
	 */
	function getElement(inst = false) {
		if (inst) {
			if (typeof(element) == "string") {
				return compilestring(format("return %s(\"%s\")", this.elementType, this.element))();
			}
		}
		
		return this.element;
	}
	
	/**
	 * @returns [string]: element type
	 */
	function getElementType() {
		return this.elementType;
	}
	
	/**
	 * @returns [integer]: animation type
	 */
	function getElementAnimationType() { 
		return this.elementAnimationType;
	}
	
	/**
	 * @returns [table]: animation info
	 */
	function getElementAnimationInfo() {
		return this.elementAnimationInfo;
	}
}