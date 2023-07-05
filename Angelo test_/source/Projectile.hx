package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.nape.FlxNapeSprite;
import openfl.Assets;

/**
 * @author TiagoLr ( ~~~ProG4mr~~~ )
 */
class Projectile extends FlxNapeSprite {

	var speed:Float = 0;
	var spriteWidth:Int = 31;
	var spriteHeight:Int = 25;
	
	public function new (x:Int, y:Int, speed:Float) {
		super(x  + 10, y + 10, "assets/testBullet.png");
		createRectangularBody(spriteWidth, spriteHeight);
		this.speed = speed;
		body.allowRotation = false;
		setDrag(0.98, 1);
		velocity.x = 20;
		velocity.y = 20;
		trace("Bullet X: " +  x + ", Bullet Y: " + y);
	}
	
	override public function update(elapsed:Float):Void {
		super.update(elapsed);
		x += speed;
		y += speed;
		trace("X: " + this.x + ", Y: " + this.y);
	}

	
}