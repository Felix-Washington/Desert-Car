package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.nape.FlxNapeSprite;
import openfl.Assets;
import Gun;

/**
 * @author TiagoLr ( ~~~ProG4mr~~~ )
 */
class Car extends FlxNapeSprite
{
	//public var shadow:FlxSprite;
	public var gun1:Gun;

	public function new (){
		super(FlxG.width, FlxG.height, "assets/Car1.png");
		createRectangularBody(120, 150);
		this.scale.set(0.15, 0.15);
		body.allowRotation = false;
		setDrag(1, 2);
		gun1 = new Gun(this, 30, 40);

	}
	
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
		gun1.setPos(Std.int(x+30), Std.int(y+40));
		
		if (FlxG.camera.target != null && FlxG.camera.followLead.x == 0) // target check is used for debug purposes.
		{
			x = Math.round(x); // Smooths camera and orb shadow following. Does not work well with camera lead.
			y = Math.round(y); // Smooths camera and orb shadow following. Does not work well with camera lead.
		}
		
		//shadow.x = Math.round(x);
		//shadow.y = Math.round(y);
	}
}