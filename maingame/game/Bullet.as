package game {
	
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import game.Player;
	
	
	public class Bullet extends MovieClip {
		private var stageRef: Stage;
		private var speed: Number = 40; //speed that the bullet will travel at
		public var xVel: Number = 0;
		public var yVel: Number = 0;
		public var rotationInRadians = 0;
		
		public var damage: Number;
		
		public function Bullet(stageRef: Stage, X: int, Y: int, rotationInDegrees: Number, playerObj: Player) {
			damage = playerObj.gunDamage;
			this.stageRef = stageRef;
			this.x = X;
			this.y = Y;
			this.rotation = rotationInDegrees;
			this.rotationInRadians = rotationInDegrees * Math.PI / 180;
			
			this.addEventListener(Event.ENTER_FRAME, loop);
		}
	
		public function loop(e:Event): void
		{
			xVel = Math.cos(rotationInRadians) * speed; //uses the cosine to get the xVel from the speed and rotation
			yVel = Math.sin(rotationInRadians) * speed; //uses the sine to get the yVel

			x += xVel; //updates the position
			y += yVel;
			if (x > 1200 || x < -1200 || y > 1200 || y < -1200) { //out of bounds
				removeEventListener(Event.ENTER_FRAME, loop);
				this.parent.removeChild(this); //remove the bullet
			}
		}
	
		public function removeBullet(): void {
			removeEventListener(Event.ENTER_FRAME, loop);
			this.parent.removeChild(this); //remove the bullet
		}
	}
	
}
