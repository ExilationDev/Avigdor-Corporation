package game {
	
	import flash.display.MovieClip;
	
	
	public class Weapon extends MovieClip {
		
		public var maxCapacity: Array = [0, 25, 100, 28];
		public var ammoCapacity: Array = [0, 25, 100, 28]; //int, WeaponCapacity
		public var ammoAmount: Array = [0, 150, 2147483600, 196]; //int, TotalAmmo
		public var weaponName: Array = ["Baton", "Void Repeater", "Developer's Pistol", "AGlock-10"]; //string
		public var isGun: Array = [false, true, true, true];
		public var isAutomatic: Array = [false, false, true, true];
		public var automaticDelay: Array = [0, 0, 1, 5.5];
		
		//Damage
		public var minDamage: Array = [25, 15, 1, 15];
		public var maxDamage: Array = [30, 35, 1000, 20];
		
		public function Weapon() {
			// constructor code
		}
	}
	
}
