package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.nape.FlxNapeSprite;
import openfl.Assets;

/**
 * @author TiagoLr ( ~~~ProG4mr~~~ )
 */
class Car extends FlxNapeSprite
{
	//public var shadow:FlxSprite;

	public function new (){
		super(FlxG.width, FlxG.height, "assets/Car1.png");
		createRectangularBody(120, 150);
		this.scale.set(0.15, 0.15);
		body.allowRotation = false;
		setDrag(3, 3);	
	}
	
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
		
		if (FlxG.camera.target != null && FlxG.camera.followLead.x == 0) // target check is used for debug purposes.
		{
			x = Math.round(x); // Smooths camera and orb shadow following. Does not work well with camera lead.
			y = Math.round(y); // Smooths camera and orb shadow following. Does not work well with camera lead.
		}
		
		//shadow.x = Math.round(x);
		//shadow.y = Math.round(y);
	}
}