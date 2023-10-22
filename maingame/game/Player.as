package game {

	import flash.display.MovieClip;
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.geom.Point;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.ui.Keyboard;
	import game.Bullet;
	import game.Weapon;


	public class Player extends MovieClip {

		//var direction:Point = new Point(0, 0);
		var player: MovieClip = this as MovieClip;
		var speed: Number;
		var dashSpd: Number = 25;
		var normSpd: Number = 10;
		var W, A, S, D, LeftShift: Boolean = false;
		public var onCooldownDash: Boolean = false;
		public var cooldown: Number = 3.0;
		public var bulletList: Array = [];

		var offset: Point = new Point();

		//Weapon Stats
		public var gunCapacity: int = 10;
		public var gunAmount: int = 10;
		public var gunName: String = "Default";
		public var currentWeapon: int = 0; //default
		public var weaponGun: Weapon = gun;
		public var gunDamage: Number = 0;

		public var isAiming: Boolean = false;
		var isShooting: Boolean = false;
		var isAutoShoot: Boolean = false;
		var timer: int = 0;

		public function Player() {
			this.addEventListener(Event.ENTER_FRAME, Update);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, KeyDown);
			stage.addEventListener(KeyboardEvent.KEY_UP, KeyUp);
			stage.addEventListener(MouseEvent.CLICK, shootClick, false, 0, true);
			stage.addEventListener(MouseEvent.RIGHT_MOUSE_DOWN, aimingStance);
			stage.addEventListener(MouseEvent.RIGHT_MOUSE_UP, aimingStanceUp);
			stage.addEventListener(MouseEvent.MOUSE_DOWN, ShootFire);
			stage.addEventListener(MouseEvent.MOUSE_UP, ShootStop);
			stage.addEventListener(MouseEvent.MOUSE_WHEEL, SwitchWeapons);
			StartGunUpdate();
			WeaponStartUpdate();
		}
	
		public function ShootFire(e: MouseEvent): void {
			if (gunCapacity > 0 && gun.isGun[currentWeapon])
				isAutoShoot = true;
			if (!gun.isGun[currentWeapon])
				isAutoShoot = true;
			
			shootBullet();
		}
	
		public function ShootStop(e: MouseEvent): void {
			isAutoShoot = false;
		}
	
		public function shootClick(e: MouseEvent): void {
			//empty
		}

		public function aimingStance(e: MouseEvent): void {
			isAiming = true;
		}

		public function aimingStanceUp(e: MouseEvent): void {
			isAiming = false;
		}

		function random(min: Number = 0, max: Number = Number.MAX_VALUE): int {
			if (min == max) return min;
			if (min < max) return min + (Math.random() * (max - min + 1));
			else return max + (Math.random() * (min - max + 1));
		}

		public function shootBullet(): void {
			isShooting = true;
			if (isAutoShoot)
				WeaponStartUpdate();
			
			if (gunCapacity != 0) {
				if (gun.isAutomatic[currentWeapon]) {
					timer = gun.automaticDelay[currentWeapon];
					if (!isAutoShoot) {
						this.removeEventListener(Event.ENTER_FRAME, autoShootUpdate);
						return;
					}
					this.addEventListener(Event.ENTER_FRAME, autoShootUpdate);
				} else {
					this.removeEventListener(Event.ENTER_FRAME, autoShootUpdate);
				}
				
				gunCapacity -= 1;
				gun.ammoCapacity[currentWeapon] = gunCapacity;
				var bullet: Bullet = new Bullet(stage, (x - 1280 / 2) + offset.x, (y - 720 / 2) + offset.y, isAiming ? gun.rotation+random(-1.0, 1.0) : gun.rotation+random(-15.0, 15.0), this);
				bullet.addEventListener(Event.REMOVED_FROM_STAGE, bulletRemoved, false, 0, true);
				bulletList.push(bullet);
				if (isAiming) {
					playFieldObj.addChild(bullet);
					playFieldObj.setChildIndex(bullet, 1);
				} else {
					//bullet.rotation = gun.rotation + random(-4.0, 4.0);
					playFieldObj.addChild(bullet);
					playFieldObj.setChildIndex(bullet, 1);
				}
			}
		}
	
		function autoShootUpdate(e:Event) : void {
			if (timer > 0) {
				timer -= 1;
				return;
			}
		
			if (gunCapacity != 0)
				shootBullet();
			else 
				this.removeEventListener(Event.ENTER_FRAME, autoShootUpdate);
		}

		function WeaponStartUpdate() {
			if (!gun.isGun[currentWeapon]) {
				if (isShooting) {
					gun.testMelee.gotoAndPlay(2);
					isShooting = false;
				}
			} else {
				if (isShooting) {
					if (gun.ammoCapacity[currentWeapon] != 0) {
						gun.testPistol.gotoAndPlay(2);
					}
					isShooting = false;
				}
			}
		}

		public function bulletRemoved(e: Event): void {
			e.currentTarget.removeEventListener(Event.REMOVED_FROM_STAGE, bulletRemoved); //remove the event listener so we don't get any errors
			bulletList.splice(bulletList.indexOf(e.currentTarget), 1); //remove this bullet from the bulletList array
		}

		function Update(e: Event) {
			if (isAiming) {
				player.playerAnim.gotoAndStop(2);
			}
			offset = new Point(85 * Math.cos(-gun.rotation / 57.5), 85 * -Math.sin(-gun.rotation / 57.5));
		
			var velocity: Point = new Point(0, 0);

			if (W) {
				y -= isAiming ? speed / 2 : speed;
				velocity.y -= isAiming ? speed / 2 : speed;
			}
			if (A) {
				x -= isAiming ? speed / 2 : speed;
				velocity.x -= isAiming ? speed / 2 : speed;
			}
			if (S) {
				y += isAiming ? speed / 2 : speed;
				velocity.y += isAiming ? speed / 2 : speed;
			}
			if (D) {
				x += isAiming ? speed / 2 : speed;
				velocity.x += isAiming ? speed / 2 : speed;
			}
			
			if ((velocity.x > 0 || velocity.x < 0 || velocity.y > 0 || velocity.y < 0) && !isAiming) {
				player.playerAnim.gotoAndStop(3);
			} else if (!isAiming) {
				player.playerAnim.gotoAndStop(1);
			}

			if (LeftShift && !onCooldownDash && !isAiming) {
				onCooldownDash = true;
			}

			if (onCooldownDash && cooldown > 0) {
				if (cooldown > 2)
					speed = dashSpd;
				else
					speed = normSpd;
				cooldown -= 0.1;
			} else if (onCooldownDash) {
				onCooldownDash = false;
				cooldown = 3.0;
			} else {
				speed = normSpd;
			}
			StartGunUpdate();
		}

		function KeyDown(e: KeyboardEvent) {
			//trace(e.keyCode);
			switch (e.keyCode) {
				case 87:
					W = true;
					break;
				case 65:
					A = true;
					break;
				case 83:
					S = true;
					break;
				case 68:
					D = true;
					break;
				case 16:
					LeftShift = true;
					break;
				case 49: //1st Weapon
					currentWeapon = 0;
					break;
				case 50: //2nd Weapon
					currentWeapon = 1;
					break;
				case 51: //3rd Weapon
					currentWeapon = 2;
					break;
				case 52: //4th Weapon
					currentWeapon = 3;
					break;
				case 82: //Reload
					if (gun.isGun[currentWeapon] && !isAutoShoot)
						Reload();
					break;
			}

			StartGunUpdate();
			//WeaponStartUpdate();
			gun.gotoAndStop(currentWeapon + 1);
		}

		function KeyUp(e: KeyboardEvent) {
			switch (e.keyCode) {
				case 87:
					W = false;
					break;
				case 65:
					A = false;
					break;
				case 83:
					S = false;
					break;
				case 68:
					D = false;
					break;
				case 16:
					LeftShift = false;
					break;
			}
		}
	
		function SwitchWeapons(e:MouseEvent) {
			trace(gun.weaponName.length);
			if(e.delta > 0) {
				currentWeapon += 1;
			} else {
				currentWeapon -= 1;
			}
		
			if (currentWeapon < 0) {
				currentWeapon = gun.weaponName.length - 1;
			} else if (currentWeapon > gun.weaponName.length - 1) {
				currentWeapon = 0;
			}
		
			StartGunUpdate();
			gun.gotoAndStop(currentWeapon + 1);
		}

		function StartGunUpdate() {
			gunCapacity = gun.ammoCapacity[currentWeapon];
			gunAmount = gun.ammoAmount[currentWeapon];
			gunName = gun.weaponName[currentWeapon];
			gunDamage = random(gun.minDamage[currentWeapon], gun.maxDamage[currentWeapon]);
		}

		function Reload() {
			if (gun.ammoAmount[currentWeapon] == 0) {
				return;
			}
			gun.ammoAmount[currentWeapon] += gun.ammoCapacity[currentWeapon];
			gun.ammoCapacity[currentWeapon] = 0;
			gun.testPistol.gotoAndPlay(9);

			if (gun.ammoAmount[currentWeapon] < gun.maxCapacity[currentWeapon]) {
				gun.ammoCapacity[currentWeapon] += gun.ammoAmount[currentWeapon];
				gun.ammoAmount[currentWeapon] -= gun.ammoCapacity[currentWeapon];
			} else {
				gun.ammoCapacity[currentWeapon] += gun.maxCapacity[currentWeapon];
				gun.ammoAmount[currentWeapon] -= gun.maxCapacity[currentWeapon];
			}
		}
	}

}