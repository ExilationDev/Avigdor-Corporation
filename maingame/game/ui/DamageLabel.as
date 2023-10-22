package game.ui {
	
	import flash.display.MovieClip;
	import flash.text.TextField;
	import flash.events.Event;
	
	
	public class DamageLabel extends MovieClip {
		
		var damageText;
		public var damage: Number;
		
		var timer: Number = 15;
		
		public function DamageLabel(text: Number = 0) {
			damageText = damageIndicator.graphic.damageText;
			damageText.text = text.toString();
			this.addEventListener(Event.ENTER_FRAME, Update);
		}
	
		function Update(e:Event) {
			timer -= 1;
			if (timer <= 0) {
				this.removeEventListener(Event.ENTER_FRAME, Update);
				this.parent.removeChild(this);
			}
		}
	}
	
}
