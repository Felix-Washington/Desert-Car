package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.nape.FlxNapeSprite;
import openfl.Assets;
import Orb;

/**
 * @author TiagoLr ( ~~~ProG4mr~~~ )
 */
class Shot extends FlxNapeSprite
{
	public var shadow:FlxSprite;

	public function new (){
		super(FlxG.width / 2, FlxG.height / 2, "assets/gunTest.png");
		createCircularBody(18);
		body.allowRotation = false;
		setDrag(0.98, 1);	
		this.scale.set(0.1,0.1);
	}
	
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
		
		if (FlxG.camera.target != null && FlxG.camera.followLead.x == 0) // target check is used for debug purposes.
		{
			x = Math.round(x); // Smooths camera and orb shadow following. Does not work well with camera lead.
			y = Math.round(y); // Smooths camera and orb shadow following. Does not work well with camera lead.
		}
		
		shadow.x = Math.round(x);
		shadow.y = Math.round(y);
	}

	//public function follow (obj: FlxNapeSprite) {
	//	this.x = obj.x + obj.width/2;
	//	this.y = obj.y + obj.height/2;
	//}
}