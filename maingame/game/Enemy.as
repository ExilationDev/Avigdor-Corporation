package game {

	import flash.display.MovieClip;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.geom.Transform;
	import flash.geom.ColorTransform;
	import fl.motion.Color;
	import game.Player;
	import game.Weapon;
	import game.ui.DamageLabel;

	public class Enemy extends MovieClip {

		var bullet: Array = [];
		var player: Player = (root as DisplayObjectContainer).getChildByName("player") as Player;
		var weapon: Weapon = player.gun;

		var delay = 3.5; //2 frame(s)

		public var enemyId: int = 0;

		public var enemyMaxHp: Array = [100000, 100];
		var currentEnemyHp: int;

		public function Enemy() {
			currentEnemyHp = enemyMaxHp[enemyId];
			this.addEventListener(Event.ENTER_FRAME, enemyUpdate);
		}

		function random(min: Number = 0, max: Number = Number.MAX_VALUE): int {
			if (min == max) return min;
			if (min < max) return min + (Math.random() * (max - min + 1));
			else return max + (Math.random() * (min - max + 1));
		}

		function enemyUpdate(e: Event) {
			if (player.y > this.y) {
				this.parent.setChildIndex(this, this.parent.getChildIndex(player) - 1);
			} else {
				this.parent.setChildIndex(this, this.parent.getChildIndex(player) + 1);
			}

			bullet = player.bulletList;

			//DamageEnemy
			if (weapon.isGun[player.currentWeapon]) {
				for (var i = 0; i < bullet.length; i++) {
					if (bullet[i].hitTestObject(this.enemySprite)) {
						delay = 3.5;
						this.addEventListener(Event.ENTER_FRAME, enemyHitUpdate); //When on hit
						enemyDamaged(bullet[i].damage);
						bullet[i].removeBullet();
					}
				}
			} else {
				if (weapon.testMelee.hitbox != null)
					if (weapon.testMelee.hitbox.hitTestObject(this.enemySprite)) {
						delay = 3.5;
						this.addEventListener(Event.ENTER_FRAME, enemyHitUpdate); //When on hit
						enemyDamaged(player.gunDamage);
					}
			}
			enemyHealthbar.bar.scaleX = currentEnemyHp / enemyMaxHp[enemyId];
		}

		function enemyHitUpdate(e: Event) {
			var color: Color = new Color();
			delay -= 1;
			if (delay <= 0) {
				color.brightness = 0;
				this.removeEventListener(Event.ENTER_FRAME, enemyHitUpdate);
			} else {
				color.brightness = 0.3;
			}
			enemySprite.transform.colorTransform = color;
		}

		function enemyDamaged(damage: Number) {
			var damageLabel: DamageLabel = new DamageLabel(damage);
			currentEnemyHp -= damage;
			damageLabel.rotation += random(-15.0, 15.0);
			damageLabel.x += this.x + random(-25.0, 25.0);
			damageLabel.y = this.y + -this.enemySprite.height + 20;
			this.parent.addChild(damageLabel);
			this.parent.setChildIndex(damageLabel, this.parent.getChildIndex((root as DisplayObjectContainer).getChildByName("crosshair")) - 1);
			if (currentEnemyHp <= 0) {
				this.parent.removeChild(this);
				this.removeEventListener(Event.ENTER_FRAME, enemyUpdate);
				this.removeEventListener(Event.ENTER_FRAME, enemyHitUpdate);
			}
		}
	}
}
