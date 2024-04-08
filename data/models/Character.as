package data.models
{
	import data.Constant;
	
	public class Character
	{
		private var name:String = "";
		public var charType:String = "";
		private var level:int = 1;
		private var hp:int = 100;
		private var maxHP:int = 100;
		private var cp:int = 100;
		private var maxCP:int = 100;
		private var agility:int = 10;
		private var critical:Number = 5;
		private var dodge:Number = 5;
		private var purify:Number = 5;
		private var buffList:Object = {};
		private var debuffList:Object = {};
		private var isDead:Boolean = false;
		private var atb:int = 0;

		private var skillList:Array = [];
		private var skillArr:Array = [];
		private var actionList:Array = [];
		public var cooldownList:Array = [];

		public function Character()
		{
		}

		// public function Character(obj:Object)
		// {
		// this.level = obj["level"];
		// this.hp = obj["hp"];
		// this.maxHP = obj["maxHP"];
		// this.cp = obj["cp"];
		// this.maxCP = obj["maxCP"];
		// this.agility = obj["agility"];
		// this.critical = obj["critical"];
		// this.dodge = obj["dodge"];
		// this.purify = obj["purify"];
		// this.buffList = obj["buff"];
		// this.debuffList = obj["debuff"];
		// this.isDead = obj["isDead"];
		// }

		public function setName(name:String):void
		{
			this.name = name;
		}

		public function getName():String
		{
			return this.name;
		}

		public function setHP(health:int):void
		{
			this.hp = health;
		}

		public function setCP(chakra:int):void
		{
			this.cp = chakra;
		}

		public function updateHP(health:int):void
		{
			this.hp += health;
		}

		public function updateCP(chakra:int):void
		{
			this.cp += chakra;
		}

		public function setBuffList(buffListay:Object):void
		{
			this.buffList = buffListay;
		}

		public function setDebuffList(debuffListay:Object):void
		{
			this.debuffList = debuffListay;
		}

		public function setIsDead(dead:Boolean):void
		{
			this.isDead = dead;
		}

		public function getLevel():int
		{
			return this.level;
		}

		public function getHP():int
		{
			if (this.hp < 0)
			{
				this.hp = 0;
			}
			if (this.hp > this.maxHP)
			{
				this.hp = this.maxHP;
			}
			return this.hp;
		}

		public function getCP():int
		{
			if (this.cp < 0)
			{
				this.cp = 0;
			}
			if (this.cp > this.maxCP)
			{
				this.cp = this.maxCP;
			}
			return this.cp;
		}

		public function getMaxHP():int
		{
			return this.maxHP;
		}

		public function getMaxCP():int
		{
			return this.maxCP;
		}

		public function getAgility():int
		{
			return this.agility;
		}

		public function getCritical():int
		{
			return this.critical;
		}

		public function getDodge():int
		{
			return this.dodge;
		}

		public function getPurify():int
		{
			return this.purify;
		}

		public function getBuffList():Object
		{
			return this.buffList;
		}

		public function getDebuffList():Object
		{
			return this.debuffList;
		}

		public function getCooldownList():Array
		{
			return this.cooldownList;
		}

		public function setCooldownList(cdList:Array):void
		{
			this.cooldownList = cdList;
		}

		public function getIsDead():Boolean
		{
			return this.isDead;
		}

		public function getATB():int
		{
			return this.atb;
		}

		public function getSkillList():Array
		{
			return this.skillList;
		}

		public function getSkillArr():Array
		{
			return this.skillArr;
		}

		public function getActionList():Array
		{
			return this.actionList;
		}

		public function setActionList(actionList:Array):void
		{
			this.actionList = actionList;
		}

		public function resetATB():void
		{
			this.atb = this.atb % Constant.MAX_ATB_VALUE;
			// this.atb = 0;
		}

		public function updateATB(val:int):void
		{
			this.atb += this.agility * val;
		}

		public function isATBFull():Boolean
		{
			return this.atb >= Constant.MAX_ATB_VALUE;
		}
	}
}