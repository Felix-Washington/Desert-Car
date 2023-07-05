package;

import flash.Lib;
import flash.display.BlendMode;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.nape.FlxNapeSpace;
import flixel.util.FlxSpriteUtil;
import nape.geom.Vec2;
import openfl.Assets;

/**
 * @author TiagoLr ( ~~~ProG4mr~~~ )
 */
class PlayState extends FlxState
{
	// Demo arena boundaries
	static var LEVEL_MIN_X;
	static var LEVEL_MAX_X;
	static var LEVEL_MIN_Y;
	static var LEVEL_MAX_Y;
	
	#if TRUE_ZOOM_OUT
	private var firstUpdate:Bool;
	#end
	private var car:Car;
	private var shot:Shot;
	private var sinAtual:Float;
	private var cosAtual:Float;
	//private var orbShadow:FlxSprite;
	private var hud:HUD;
	private var hudCam:FlxCamera;
	private var overlayCamera:FlxCamera;

	override public function create():Void 
	{	
		FlxNapeSpace.init();
		
		LEVEL_MIN_X = -Lib.current.stage.stageWidth / 2;
		LEVEL_MAX_X = Lib.current.stage.stageWidth * 1.5;
		LEVEL_MIN_Y = -Lib.current.stage.stageHeight / 4;
		LEVEL_MAX_Y = Lib.current.stage.stageHeight * 5;
		
		super.create();
		
		FlxG.mouse.visible = false;
		
		#if TRUE_ZOOM_OUT
		FlxG.width = 640; // For 1/2 zoom out
		FlxG.height = 480; // For 1/2 zoom out
		firstUpdate = true;
		#end
		
		FlxNapeSpace.velocityIterations = 5;
		FlxNapeSpace.positionIterations = 5;
		
		createFloor();
		FlxNapeSpace.createWalls(LEVEL_MIN_X, LEVEL_MIN_Y, LEVEL_MAX_X, LEVEL_MAX_Y);
		// Walls border.
		add(new FlxSprite(-FlxG.width / 2, -FlxG.height / 2, "assets/Border.png"));
		
		 //Player orb
		//orbShadow = new FlxSprite(FlxG.width / 2, FlxG.height / 2, "assets/OrbShadow.png");
		//orbShadow.centerOffsets();
		//orbShadow.blend = BlendMode.MULTIPLY;
		
		car = new Car();
		shot = new Shot();
		
		//add(orbShadow);
		add(car);
		add(car.gun1);
	
		
		//orb.shadow = orbShadow;
		
		// Other orbs
		//for (i in 0...5) 
		//{
		//	var otherOrbShadow = new FlxSprite(100, 100, "assets/OtherOrbShadow.png");
		//	otherOrbShadow.centerOffsets();
		//	otherOrbShadow.blend = BlendMode.MULTIPLY;
		//	
		//	var otherOrb = new Orb();
		//	otherOrb.loadGraphic("assets/OtherOrb.png", true, 140, 140);
		//	otherOrb.createCircularBody(50);
		//	otherOrb.setBodyMaterial(1, 0.2, 0.4, 0.5);
		//	otherOrb.antialiasing = true;
		//	otherOrb.setDrag(1, 1);
		//	
		//	add(otherOrbShadow);
		//	add(otherOrb);
		//	
		//	otherOrb.shadow = otherOrbShadow;
		//	
		//	switch (i) 
		//	{
		//		case 0: 
		//			otherOrb.body.position.setxy(320 - 400, 240 - 400);
		//			otherOrb.animation.frameIndex = 0;
		//		case 1: 
		//			otherOrb.body.position.setxy(320 + 400, 240 - 400); 
		//			otherOrb.animation.frameIndex = 4;
		//		case 2:
		//			otherOrb.body.position.setxy(320 + 400, 240 + 400); 
		//			otherOrb.animation.frameIndex = 3;
		//		case 3:
		//			otherOrb.body.position.setxy( -300, 240); 
		//			otherOrb.animation.frameIndex = 2;
		//		case 4:
		//			otherOrb.body.position.setxy(0, 240 + 400); 
		//			otherOrb.animation.frameIndex = 1;
		//	}
		//	otherOrb.body.velocity.setxy(Std.random(150) - 75, Std.random(150) - 75);
		//}
		// Camera Overlay
		var cameraOverlay = new FlxSprite(-10000, -10000);
		cameraOverlay.makeGraphic(640, 480, 0x0);
		cameraOverlay.antialiasing = true;
		var offset:Int = 100;
		
		var lineStyle:LineStyle = { color: 0xFFFFFFFF, thickness: 3 };
		
		// Left Up Corner
		FlxSpriteUtil.drawLine(cameraOverlay, offset, offset, offset + 50, offset, lineStyle);
		FlxSpriteUtil.drawLine(cameraOverlay, offset, offset, offset, offset + 50, lineStyle);
		// Right Up Corner
		FlxSpriteUtil.drawLine(cameraOverlay, 640 - offset, offset, 640 - offset - 50, offset, lineStyle);
		FlxSpriteUtil.drawLine(cameraOverlay, 640 - offset, offset, 640 - offset, offset + 50, lineStyle);
		// Bottom Left Corner
		FlxSpriteUtil.drawLine(cameraOverlay, offset, 480 - offset, offset + 50, 480 - offset, lineStyle);
		FlxSpriteUtil.drawLine(cameraOverlay, offset, 480 - offset, offset, 480 - offset - 50, lineStyle);
		// Bottom Right Corner
		FlxSpriteUtil.drawLine(cameraOverlay, 640 - offset, 480 - offset, 640 - offset - 50, 480 - offset, lineStyle);
		FlxSpriteUtil.drawLine(cameraOverlay, 640 - offset, 480 - offset, 640 - offset, 480 - offset - 50, lineStyle);
		
		overlayCamera = new FlxCamera(0, 0, 640, 720);
		overlayCamera.follow(cameraOverlay);
		overlayCamera.bgColor = 0x0;
		FlxG.cameras.add(overlayCamera);
		add(cameraOverlay);
		
		hud = new HUD();
		add(hud);
		
		FlxG.camera.setScrollBoundsRect(LEVEL_MIN_X , LEVEL_MIN_Y , LEVEL_MAX_X + Math.abs(LEVEL_MIN_X), LEVEL_MAX_Y + Math.abs(LEVEL_MIN_Y), true);
		FlxG.camera.follow(car, NO_DEAD_ZONE, 2);
		
		#if TRUE_ZOOM_OUT
		hudCam = new FlxCamera(440 + 50, 0 + 45, hud.width, hud.height); // +50 + 45 For 1/2 zoom out.
		#else
		hudCam = new FlxCamera(440, 0, hud.width, hud.height);
		#end
		hudCam.zoom = 1; // For 1/2 zoom out.
		hudCam.follow(hud.background, FlxCameraFollowStyle.NO_DEAD_ZONE);
		hudCam.alpha = .5;
		FlxG.cameras.add(hudCam);
	}
	
	public function setZoom(zoom:Float)
	{
		if (zoom < .5) zoom = .5;
		if (zoom > 4) zoom = 4;
		
		zoom = Math.round(zoom * 10) / 10; // corrects float precision problems.
		
		FlxG.camera.zoom = zoom;
		
		#if TRUE_ZOOM_OUT
		zoom += 0.5; // For 1/2 zoom out.
		zoom -= (1 - zoom); // For 1/2 zoom out.
		#end
		
		var zoomDistDiffY;
		var zoomDistDiffX;
		
		
		if (zoom <= 1) 
		{
			zoomDistDiffX = Math.abs((LEVEL_MIN_X + LEVEL_MAX_X) - (LEVEL_MIN_X + LEVEL_MAX_X) / 1 + (1 - zoom));
			zoomDistDiffY = Math.abs((LEVEL_MIN_Y + LEVEL_MAX_Y) - (LEVEL_MIN_Y + LEVEL_MAX_Y) / 1 + (1 - zoom));
			#if TRUE_ZOOM_OUT
			zoomDistDiffX *= 1; // For 1/2 zoom out - otherwise -0.5 
			zoomDistDiffY *= 1; // For 1/2 zoom out - otherwise -0.5
			#else
			zoomDistDiffX *= -.5;
			zoomDistDiffY *= -.5;
			#end
		}
		else
		{
			zoomDistDiffX = Math.abs((LEVEL_MIN_X + LEVEL_MAX_X) - (LEVEL_MIN_X + LEVEL_MAX_X) / zoom);
			zoomDistDiffY = Math.abs((LEVEL_MIN_Y + LEVEL_MAX_Y) - (LEVEL_MIN_Y + LEVEL_MAX_Y) / zoom);
			#if TRUE_ZOOM_OUT
			zoomDistDiffX *= 1; // For 1/2 zoom out - otherwise 0.5
			zoomDistDiffY *= 1; // For 1/2 zoom out - otherwise 0.5
			#else
			zoomDistDiffX *= .5;
			zoomDistDiffY *= .5;
			#end
		}
		
		FlxG.camera.setScrollBoundsRect(LEVEL_MIN_X - zoomDistDiffX, 
							   LEVEL_MIN_Y - zoomDistDiffY,
							   (LEVEL_MAX_X + Math.abs(LEVEL_MIN_X) + zoomDistDiffX * 2),
							   (LEVEL_MAX_Y + Math.abs(LEVEL_MIN_Y) + zoomDistDiffY * 2),
							   false);
		
		hud.updateZoom(FlxG.camera.zoom);
	}

	private function createFloor() 
	{
		// CREATE FLOOR TILES
		var	FloorImg = Assets.getBitmapData("assets/FloorTexture.png");
		var ImgWidth = FloorImg.width;
		var ImgHeight = FloorImg.height;
		var i = LEVEL_MIN_X; 
		var j = LEVEL_MIN_Y; 
		
		while (i <= LEVEL_MAX_X)  
		{
			while (j <= LEVEL_MAX_Y)
			{
				var spr = new FlxSprite(i, j, FloorImg);
				add(spr);
				j += ImgHeight;
			}
			i += ImgWidth;
			j = LEVEL_MIN_Y;
		}
	}
	
	override public function update(elapsed:Float):Void 
	{	
		#if TRUE_ZOOM_OUT
		if (firstUpdate) // For 1/2 zoom out.
		{
			setZoom(1);
			firstUpdate = false;
		}
		#end

		super.update(elapsed);
		
		var speed = 200;
		//car.angle = 90
		//c.x+=sin(c.angle)*c.speed;
		var testX = Math.sin(car.angle) * speed;
		var testY = Math.cos(car.angle) * speed;
		
		if (FlxG.keys.anyPressed([32])){
			car.gun1.fire();
			add(car.gun1.proj);
		}

		if (FlxG.keys.anyPressed([W, UP]))
		 {
			car.body.applyImpulse(new Vec2(testX, testY*-1));
			trace("Car angle = " + car.angle);
			trace("testX = " + testX);
			trace("testY = " + testY);
			trace("Sin = " + Math.sin(car.angle));
			trace("Cos = " + Math.cos(car.angle));

			if (FlxG.keys.anyPressed([A, LEFT])) 
			{	
				car.angle -= 1;				
				car.body.applyImpulse(new Vec2(testX*-1, testY * 1));
			}

			if (FlxG.keys.anyPressed([D, RIGHT]))
			{
				car.angle += 1;			
				car.body.applyImpulse(new Vec2( testX*1, testY * -1));
			}
		}
		if (FlxG.keys.anyPressed([S, DOWN]))
		 {
			car.body.applyImpulse(new Vec2( testX, testY));

			if (FlxG.keys.anyPressed([A, LEFT]))
			{		
				car.angle -= 1;
				//orb.body.applyImpulse(new Vec2( Math.sin(orb.angle)*speed, Math.cos(orb.angle)*speed*-1 ));
				car.body.applyImpulse(new Vec2( -speed, 0));
			}
			
			if (FlxG.keys.anyPressed([D, RIGHT]))
			{
				car.angle += 1;			
				car.body.applyImpulse(new Vec2(speed, 0));
			}
		}
		
		
			
		if (FlxG.keys.justPressed.Y) 
			setStyle(1);
		if (FlxG.keys.justPressed.H) 
			setStyle( -1);
			
		if (FlxG.keys.justPressed.U)
			setLerp(.1);
		if (FlxG.keys.justPressed.J)
			setLerp( -.1);
			
		if (FlxG.keys.justPressed.I)
			setLead(.5);
		if (FlxG.keys.justPressed.K)
			setLead( -.5);
			
		if (FlxG.keys.justPressed.O)
			setZoom(FlxG.camera.zoom + .1);
		if (FlxG.keys.justPressed.L)
			setZoom(FlxG.camera.zoom - .1);
			
		if (FlxG.keys.justPressed.M)
			FlxG.camera.shake();
		
	}
	
	private function setLead(lead:Float) 
	{
		var cam = FlxG.camera;
		cam.followLead.x += lead;
		cam.followLead.y += lead;
		
		if (cam.followLead.x < 0)
		{
			cam.followLead.x = 0;
			cam.followLead.y = 0;
		}
		
		hud.updateCamLead(cam.followLead.x);
	}
	
	private function setLerp(lerp:Float) 
	{
		var cam = FlxG.camera;
		cam.followLerp += lerp;
		cam.followLerp = Math.round(10 * cam.followLerp) / 10; // adding or subtracting .1 causes roundoff errors
		hud.updateCamLerp(cam.followLerp);
	}
	
	private function setStyle(i:Int) 
	{	
		var newCamStyleIndex:Int = Type.enumIndex(FlxG.camera.style) + i;
		newCamStyleIndex < 0 ? newCamStyleIndex += 6 : newCamStyleIndex %= 6;
		
		var newCamStyle = Type.createEnumIndex(FlxCameraFollowStyle, newCamStyleIndex);
		FlxG.camera.follow(car, newCamStyle, FlxG.camera.followLerp);
		
		hud.updateStyle(Std.string(FlxG.camera.style));
		
		if (FlxG.camera.style == SCREEN_BY_SCREEN)
		{
			setZoom(1);
		}
	}
	
}