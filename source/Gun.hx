package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.nape.FlxNapeSprite;
import openfl.Assets;
import flixel.group.FlxGroup;
import Projectile;

/**
 * @author TiagoLr ( ~~~ProG4mr~~~ )
 */
class Gun extends FlxSprite {

	private var healthCap:Int;
	private var healthActual:Int;
	private var ammoCap:Int;
	private var ammoActual:Int;
	private var ammoReserve:Int;
	private var damage:Float;
	private var speedFire:Float;
	private var speedReload:Float;
	public var proj_set:FlxGroup;
	
	public function new (obj:FlxNapeSprite, x:Int, y:Int) {
		super();
		new FlxSprite (300,300, "assets/testGun.png");
		this.x = obj.x + x;
		this.y = obj.y + y;
		this.healthCap = 100;
		this.healthActual = healthCap;
		this.ammoCap = 10;
		this.ammoActual = ammoCap;
		this.ammoReserve = ammoCap * 3;
		this.damage = 2.8;
		this.speedFire = 0.2;
		this.speedReload = 1.5;
		proj_set = new FlxGroup();
	}

	public function gunStats (healthCap:Int, ammoCap:Int, damage:Int, speedFire:Float, speedReload:Float):Void {
		this.healthCap = healthCap;
		this.healthActual = healthCap;
		this.ammoCap = ammoCap;
		this.ammoActual = ammoCap;
		this.ammoReserve = ammoCap * 3;
		this.damage = damage;
		this.speedFire = speedFire;
		this.speedReload = speedReload;
	}

	public function fire (speed:Float):Void {
		//Bem legal, so que, NAO FUNCIONA
		trace("create bullet");
		var proj = new Projectile (Std.int(this.x/2), Std.int(this.y/2), speed);
		proj.velocity.x = 5;
		proj.velocity.y = 5;
		proj_set.add(proj);
		proj_set.draw();
		
	}

	public function reload ():Void {
		this.ammoActual = ammoCap;
	}



	public function getHealthCap ():Int {
		return healthCap;
	}

	public function getHealthActual ():Int {
		return healthActual;
	}

	public function setHealthActual (healthActual:Int):Void {
		this.healthActual = healthActual;
		if (this.healthActual > healthCap) {
			this.healthActual = healthCap;
		}
	}

	public function getAmmoActual ():Int {
		return ammoActual;
	}

	public function setAmmoActual (ammoActual:Int):Void {
		this.ammoActual = ammoActual;
		if (this.ammoActual > ammoCap) {
			this.ammoActual = ammoCap;
		}
	}

	public function getAmmoReserve ():Int {
		return ammoReserve;
	}

	public function setAmmoReserve (ammoReserve:Int):Void {
		this.ammoReserve = ammoReserve;
	}

	public function getAmmoCap ():Int {
		return ammoCap;
	}

	public function getDamage ():Float {
		return damage;
	}

	public function getSpeedFire ():Float {
		return speedFire;
	}

	public function getSpeedReload ():Float {
		return speedReload;
	}
	
	override public function update(elapsed:Float):Void {
		super.update(elapsed);
		
	//	for (i in 0 ... proj_set.length) {
			
		//	if (proj_set[i] !=null) {

			
		//	}
		//}

	}	


	
}