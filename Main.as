package
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;

	import data.*
	import data.models.*;
	import library.*
	import utils.*
	import battle.*
	import selection.SelectionManager;

	public class Main extends MovieClip
	{
		public var allIconData:Object;
		public var allSwfData:Object;
		public var skillLib:Object;
		public var skillList:Array;
		public var swfPath:Array;
		public var characterArr:Vector.<Character> = new Vector.<Character>();

		public function Main()
		{
			this.allSwfData = {};
			this.allSwfData["length"] = 0;
			this.allIconData = {};
			this.allIconData["length"] = 0;
			this.skillLib = SkillLibrary.SKILL;
			this.skillList = Constant.SKILLS_LIST;
			this.swfPath = Constant.SWF_PATH;
			this.loadAllSwf();
			addFrameScript(0, this.frame1, 1, this.frame2, 2, this.frame3);
		}

		internal function frame1():*
		{
			stop();
		}

		internal function frame2():*
		{
			stop();
			var sm:SelectionManager = new SelectionManager(this.characterArr, this);
			sm.initSelection();
		}

		internal function frame3():*
		{
			stop();
			var bm:BattleManager = new BattleManager(characterArr, this);
			bm.startBattle();
		}

		private function loadAllSwf():void
		{
			for (var i:String in this.swfPath)
			{
				Utils.loadSwf(Utils.genIconSwfFilePath(this.swfPath[i]), this.onLoadFinish);
			}
		}

		private function onLoadFinish(e:Event):void
		{
			var fileName:String = e.target.url;
			fileName = fileName.slice(fileName.lastIndexOf("/") + 1);
			fileName = fileName.slice(0, -4);
			var oriName:String = fileName;
			fileName = fileName.replace("skill_icon_", "");

			var swfObj:MovieClip = MovieClip(e.currentTarget.content);
			this.allSwfData[oriName] = swfObj;
			this.allSwfData["length"] = this.allSwfData["length"] + 1;

			if (this.allSwfData["length"] == this.swfPath.length)
			{
				trace("Load Finish");
				gotoAndStop(2);
			}
		}

		public function actionDisplay(visible:Boolean):void
		{
			for (var i:int = 0; i < 8; i++)
			{
				this["skillMC_" + i].visible = visible;
			}
			this["btnPass"].visible = visible;
		}

		public function updateBar(playerArr:Vector.<Character>, opponentArr:Vector.<Character>):void
		{

			// for (var i:* in characterArr)
			// {
			// trace(characterArr[i].getName());
			// trace("HP: " + characterArr[i].getHP() + "/" + characterArr[i].getMaxHP());
			// trace("CP: " + characterArr[i].getCP() + "/" + characterArr[i].getMaxCP());
			// }
			// trace("=============================================");
			for (var i:* = 0; i < opponentArr.length; i++)
			{
				this["opponentMc_" + i].hpTxt.text = opponentArr[i].getHP() + "/" + opponentArr[i].getMaxHP();
				this["opponentMc_" + i]["hpBar"].scaleX = (opponentArr[i].getHP() / opponentArr[i].getMaxHP());
				this["opponentMc_" + i].cpTxt.text = opponentArr[i].getCP() + "/" + opponentArr[i].getMaxCP();
				this["opponentMc_" + i]["cpBar"].scaleX = (opponentArr[i].getCP() / opponentArr[i].getMaxCP()) * 0.8;
			}
			for (i = 0; i < playerArr.length; i++)
			{
				this["playerMc_" + i].hpTxt.text = playerArr[i].getHP() + "/" + playerArr[i].getMaxHP();
				this["playerMc_" + i]["hpBar"].scaleX = (playerArr[i].getHP() / playerArr[i].getMaxHP());
				this["playerMc_" + i].cpTxt.text = playerArr[i].getCP() + "/" + playerArr[i].getMaxCP();
				this["playerMc_" + i]["cpBar"].scaleX = (playerArr[i].getCP() / playerArr[i].getMaxCP()) * 0.8;
			}
		}

		public function initCharMC(playerArr:Vector.<Character>, opponentArr:Vector.<Character>):void
		{
			this.charMcVisible(false);
			// hideTarget(false);
			this.updateBar(playerArr, opponentArr);
			for (var i:int = 0; i < playerArr.length; i++)
			{

				// this["playerMc_" + i]["petType"].gotoAndStop(playerArr[i].getPet().getPetObj()["type"]);
				// this["playerMc_" + i]["petType"].addEventListener(MouseEvent.ROLL_OVER, showEffectList);
				// this["playerMc_" + i]["petType"].addEventListener(MouseEvent.ROLL_OUT, hideEffectList);
				Utils.removeChildIfExistAt(this["playerMc_" + i]["charMc"], 0);
				// this["playerMc_" + i]["charMc"].addChild(playerArr[i].getPet());
				this["playerMc_" + i]["nameTxt"].text = playerArr[i].getName();
				this["playerMc_" + i]["target"].visible = false;
				this["playerMc_" + i].visible = true;
			}
			for (i = 0; i < opponentArr.length; i++)
			{

				// this["opponentMc_" + i]["petType"].gotoAndStop(opponentArr[i].getPet().getPetObj()["type"]);
				// this["opponentMc_" + i]["petType"].addEventListener(MouseEvent.ROLL_OVER, showEffectList);
				// this["opponentMc_" + i]["petType"].addEventListener(MouseEvent.ROLL_OUT, hideEffectList);
				Utils.removeChildIfExistAt(this["opponentMc_" + i]["charMc"], 0);
				// this["opponentMc_" + i]["charMc"].addChild(opponentArr[i].getPet());
				this["opponentMc_" + i]["nameTxt"].text = opponentArr[i].getName();
				this["opponentMc_" + i].visible = true;
				// this["opponentMc_" + i]["maskMC"].addEventListener(MouseEvent.CLICK, onSelectTarget);
			}
		}

		public function charMcVisible(show:Boolean):void
		{
			for (var i:int = 0; i < 3; i++)
			{
				this["playerMc_" + i].visible = show;
				this["opponentMc_" + i].visible = show;
				turnVisible(show);
			}
		}

		public function turnVisible(show:Boolean):void
		{
			for (var i:int = 0; i < 3; i++)
			{
				Utils.addActiveGlowFilter(this["playerMc_" + i]["activeMc"], show);
				Utils.addActiveGlowFilter(this["opponentMc_" + i]["activeMc"], show);
			}
		}

		public function onSelectTarget(e:MouseEvent):void
		{
			// targetVisibility(false);
			// var targetName = e.target.parent.name.split("_");
			// if (nowTurn.charType == "p")
			// {
			// selectedTargetPlayer = int(targetName[1]);
			// e.target.parent["target"].visible = true;
			// defender = opponentArr[selectedTargetPlayer];
			// }
			// else
			// {
			// selectedTargetEnemy = int(targetName[1]);
			// e.target.parent["target"].visible = true;
			// defender = playerArr[selectedTargetEnemy];
			// }
		}

		public function targetVisibility(actionFinish:Boolean, playerArr:Vector.<Character>, opponentArr:Vector.<Character>):void
		{
			for (var i:int = 0; i < opponentArr.length; i++)
			{
				// var isDead = false;
				// if (i < opponentNum)
				// {
				// isDead = opponentArr[i].getIsDead();
				// }
				// if (((controlParty && nowTurn.charType == "p") || playerArr.indexOf(nowTurn) == 0) && !isDead && !actionFinish)
				// {
				// this["opponentMc_" + i]["maskMC"].addEventListener(MouseEvent.CLICK, onSelectTarget);
				// }
				// else
				// {
				// if (this["opponentMc_" + i]["maskMC"].hasEventListener(MouseEvent.CLICK))
				// {
				// this["opponentMc_" + i]["maskMC"].removeEventListener(MouseEvent.CLICK, onSelectTarget);
				// }
				// }
				this["opponentMc_" + i]["target"].visible = false;
			}
			for (i = 0; i < playerArr.length; i++)
			{
				// isDead = false;
				// if (i < playerNum)
				// {
				// isDead = playerArr[i].getIsDead();
				// }
				// if (((controlParty && nowTurn.charType == "e") || opponentArr.indexOf(nowTurn) == 0) && !isDead && !actionFinish)
				// {
				// this["playerMc_" + i]["maskMC"].addEventListener(MouseEvent.CLICK, onSelectTarget);
				// }
				// else
				// {
				// if (this["playerMc_" + i]["maskMC"].hasEventListener(MouseEvent.CLICK))
				// {
				// this["playerMc_" + i]["maskMC"].removeEventListener(MouseEvent.CLICK, onSelectTarget);
				// }
				// }
				this["playerMc_" + i]["target"].visible = false;
			}
		}
	}
}
