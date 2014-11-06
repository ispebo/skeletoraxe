package skeletoraxe.converter.utils;

import flash.geom.Rectangle;
import flash.Vector;

/**
 * @author Jukka Jylänki
 * Ported Haxe: Ispebo
 */

class MaxRectPacker
{
	public var freeRectangles		: Array<Rectangle>;

	private var binWidth			:Float;
	private var binHeight			:Float;

	public function new( width: Float, height: Float) : Void 
	{
		init(width, height);
	}

	//--------------------------------------------------------------------------------------
	public function init(width: Float, height: Float): Void 
	{
		binWidth = width;
		binHeight = height;
		freeRectangles = new Array<Rectangle>();
		freeRectangles.push(new Rectangle(0, 0, width, height));
	}
	
	//--------------------------------------------------------------------------------------

	public function quickInsert(width: Float, height: Float) : Rectangle 
	{
		var newNode:Rectangle = quickFindPositionForNewNodeBestAreaFit(width, height);

		if (newNode.height == 0) return null;
		
		var numRectanglesToProcess: Int = freeRectangles.length;
		var i: Int = 0;
		while (i < numRectanglesToProcess) {
			if (splitFreeNode(freeRectangles[i], newNode)) {
				freeRectangles.splice(i, 1);
				--numRectanglesToProcess;
				--i;
			}
			i++;
		}

		pruneFreeList();
		return newNode;
	}

	//--------------------------------------------------------------------------------------
	
	private inline function quickFindPositionForNewNodeBestAreaFit(width: Float, height: Float) : Rectangle 
	{
		var score: Float = Math.POSITIVE_INFINITY;
		var areaFit: Float;
		var r: Rectangle;
		var bestNode:Rectangle = new Rectangle();
		var l: Int = freeRectangles.length;
		//for (var i: Int = 0, l: Int = freeRectangles.length; i < l; i++) 
		for ( i in 0 ... l )
		{	
			r = freeRectangles[i];
			// Try to place the rectangle in upright (non-flipped) orientation.
			if (r.width >= width && r.height >= height) {
				areaFit = r.width * r.height - width * height;
				if (areaFit < score) {
					bestNode.x = r.x;
					bestNode.y = r.y;
					bestNode.width = width;
					bestNode.height = height;
					score = areaFit;
				}
			}
		}

		return bestNode;
	}

	//--------------------------------------------------------------------------------------
	private function splitFreeNode(freeNode: Rectangle, usedNode: Rectangle ): Bool 
	{
		var newNode:Rectangle;
		// Test with SAT if the rectangles even intersect.
		if (usedNode.x >= freeNode.x + freeNode.width ||
			usedNode.x + usedNode.width <= freeNode.x ||
			usedNode.y >= freeNode.y + freeNode.height ||
			usedNode.y + usedNode.height <= freeNode.y) {
			return false;
		}
		if (usedNode.x < freeNode.x + freeNode.width && usedNode.x + usedNode.width > freeNode.x) {
			// New node at the top side of the used node.
			if (usedNode.y > freeNode.y && usedNode.y < freeNode.y + freeNode.height) {
				newNode = freeNode.clone();
				newNode.height = usedNode.y - newNode.y;
				freeRectangles.push(newNode);
			}
			// New node at the bottom side of the used node.
			if (usedNode.y + usedNode.height < freeNode.y + freeNode.height) {
				newNode = freeNode.clone();
				newNode.y = usedNode.y + usedNode.height;
				newNode.height = freeNode.y + freeNode.height - (usedNode.y + usedNode.height);
				freeRectangles.push(newNode);
			}
		}
		if (usedNode.y < freeNode.y + freeNode.height && usedNode.y + usedNode.height > freeNode.y) {
			// New node at the left side of the used node.
			if (usedNode.x > freeNode.x && usedNode.x < freeNode.x + freeNode.width) {
				newNode = freeNode.clone();
				newNode.width = usedNode.x - newNode.x;
				freeRectangles.push(newNode);
			}
			// New node at the right side of the used node.
			if (usedNode.x + usedNode.width < freeNode.x + freeNode.width) {
				newNode = freeNode.clone();
				newNode.x = usedNode.x + usedNode.width;
				newNode.width = freeNode.x + freeNode.width - (usedNode.x + usedNode.width);
				freeRectangles.push(newNode);
			}
		}
		return true;
	}

	//--------------------------------------------------------------------------------------
	
	private function pruneFreeList(): Void  
	{
		// Go through each pair and remove any rectangle that is redundant.
		var i: Int = 0;
		var j: Int = 0;
		var len: Int = freeRectangles.length;
		var tmpRect:Rectangle;
		var tmpRect2:Rectangle;
		while (i < len) {
			j = i + 1;
			tmpRect = freeRectangles[i];
			while (j < len) {
				tmpRect2 = freeRectangles[j];
				if (isContainedIn(tmpRect,tmpRect2)) {
					freeRectangles.splice(i, 1);
					--i;
					--len;
					break;
				}
				if (isContainedIn(tmpRect2,tmpRect)) {
					freeRectangles.splice(j, 1);
					--len;
					--j;
				}
				j++;
			}
			i++;
		}
	}

	//--------------------------------------------------------------------------------------
	
	private inline function isContainedIn(a:Rectangle, b:Rectangle):Bool {
		return a.x >= b.x && a.y >= b.y	&& a.x + a.width <= b.x + b.width && a.y + a.height <= b.y + b.height;
	}
}
