package
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.filters.GlowFilter;
	import flash.utils.setTimeout;

	public class Main extends MovieClip
	{
		// FRAME 1
		public var allIconData:Object;
		public var allSwfData:Object;
		// FRAME 2
		public var skillLib:Object;
		public var skillList:Array;
		// FRAME 2 - SELECT CHARACTER
		public var newPlayerArr:Vector.<Skill> = new Vector.<Skill>();
		public var newOpponentArr:Vector.<Skill> = new Vector.<Skill>();
		public var charNum:int;
		// FRAME 2 - CHARACTER PAGE
		public var currentPage:int = 1;
		public var maxPage:int = 1;

		// FRAME 3
		public var characterArr:Vector.<Skill>;
		public var initialized:Boolean = false;
		public var turn:uint = 0;
		public var selectedTargetPlayer:uint = 0;
		public var selectedTargetOpponent:uint = 0;
		public var gameFinish:Boolean = false;
		public var skillNameTxt:String = "";
		public var numDead:Object;

		public function Main()
		{
			this.allSwfData = {};
			this.allSwfData["length"] = 0;
			this.allIconData = {};
			this.allIconData["length"] = 0;
			this.skillList = Constant.SKILL_LIST;
			this.loadAllSkill();
			addFrameScript(0, this.frame1, 1, this.frame2, 2, this.frame3);
		}

		internal function frame1()
		{
			stop();
		}

		internal function frame2()
		{
			stop();
			showSkillList();
		}

		internal function frame3()
		{
			stop();
		}

		private function loadAllSkill():void
		{
			for (var i in Constant.SWF_PATH)
			{
				Utils.loadSwf(Utils.genIconSwfFilePath(Constant.SWF_PATH[i]), this.onLoadFinish);
			}
		}

		private function onLoadFinish(e:Event):void
		{
			var fileName = e.target.url;
			fileName = fileName.slice(fileName.lastIndexOf("/") + 1);
			fileName = fileName.slice(0, -4);
			var oriName = fileName;
			trace(oriName);
			fileName = fileName.replace("skill_icon_", "");
			var front = Number(fileName.substr(0, fileName.lastIndexOf("-")));
			var back = Number(fileName.slice(fileName.lastIndexOf("-") + 1));

			var swfObj:MovieClip = MovieClip(e.currentTarget.content);
			this.allSwfData[oriName] = swfObj;
			this.allSwfData["length"] = this.allSwfData["length"] + 1;

			if (this.allSwfData["length"] == Constant.SWF_PATH.length)
			{
				trace("Load Finish");
				gotoAndStop(2);
			}

			// for (var index = front; index <= back; index++) {
			// try {
			// var num = index;
			// if (index < 10) {
			// num = "0" + index;
			// }
			// var skillName = "skill_" + num;
			// if (e.target.applicationDomain.hasDefinition(skillName)) {
			// // var obj = new Object;
			// // obj['name'] = skillName;
			// // obj['icon'] = Class(e.target.applicationDomain.getDefinition(skillName));
			// this.allIconData[skillName] = Class(e.target.applicationDomain.getDefinition(skillName));
			// trace(skillName);
			// this.allIconData["length"] = this.allIconData["length"] + 1;
			// }
			// } catch (err: Error) {
			// trace(skillName+" Error");
			// continue;
			// }
			// }

			// if(this.allIconData["length"] == this.skillList.length){
			// trace("Load Finish");
			// gotoAndStop(2)
			// }
		}

		private function showSkillList():void
		{
			var start = (currentPage - 1) * Constant.MAX_SKILL_IN_GAME;
			var end = Math.min(skillList.length, this.currentPage * Constant.MAX_SKILL_IN_GAME);
			var index = 0;
			for (var i = start; i < end; i++)
			{
				var cls = Utils.getAsset(Utils.searchIconBySkillName(allSwfData, skillList[i]), skillList[i]);
				var skillMC = cls;
				skillMC.name = skillList[i];
				Utils.removeChildIfExistAt(this["skill_" + index]["holder"], 1);
				this["skill_" + index]["holder"].addChild(skillMC);
				this["skill_" + index].visible = true;
				this["skill_" + index]["cdTxt"].text = "";
				this["skill_" + index]["cdFilter"].visible = false;
				if (Utils.hasMouseEventClick(this["skill_" + index]["maskMC"]))
				{
					Utils.removeMouseEventClick(this["skill_" + index]["maskMC"], onSelectSkill);
				}
				Utils.addMouseEventClick(this["skill_" + index]["maskMC"], onSelectSkill);
				index++;
			}
		}

		private function onSelectSkill(e:MouseEvent):void
		{
			trace(e.target.parent["holder"].getChildAt(1).name);
		}

		private function onInfoSkill(e:MouseEvent):void
		{
			// trace(e.target.parent["holder"].getChildAt(1).name);
		}

		private function onSkill(e:MouseEvent):void
		{
			// trace(e.target.parent["holder"].getChildAt(1).name);
		}
	}
}
