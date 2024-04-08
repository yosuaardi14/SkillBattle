package battle
{
	import flash.events.MouseEvent;
	import flash.utils.setTimeout;
	import data.models.*;
	import utils.*;

    public class BattleManager
    {
        public var initialized:Boolean = false;
        public var turn:uint = 0;
        public var selectedTargetPlayer:uint = 0;
        public var selectedTargetOpponent:uint = 0;
        public var attacker:Character;
        public var defender:Character;
        public var nowTurn:Character;
        public var playerArr:Vector.<Character>;
        public var opponentArr:Vector.<Character>;
        public var gameFinish:Boolean = false;
        public var skillNameTxt:String = "";
        public var numDead:Object;

        public var gameUI:Main;

        public var characterArr:Vector.<Character>;

        public function BattleManager(characterArr:Vector.<Character>, gameUI:Main)
        {
            this.gameUI = gameUI;
            this.characterArr = characterArr;
            Utils.initButton(this.gameUI["btnPass"], this.onSkill, "Dodge", true);
            for (var i:* in this.characterArr)
            {
                BattleUtils.setInitialCooldown(this.characterArr[i]);
            }
            initialized = false;
            numDead = {"p": 0, "e": 0};
            playerArr = new Vector.<Character>();
            opponentArr = new Vector.<Character>();
        }

        public function initBattle():void
        {
            if (initialized)
			{
				return;
			}
			playerArr.push(characterArr[0]);
			opponentArr.push(characterArr[1]);
			this.gameUI.initCharMC(playerArr, opponentArr);
			initialized = true;
        }

        public function startBattle():void
        {
            initBattle();
			checkDead();
			this.gameUI.targetVisibility(false, playerArr, opponentArr);
			if (checkGameFinish())
			{
				onGameFinish();
				return;
			}
			this.gameUI.updateBar(playerArr, opponentArr);
			updateCharacterATB();
			handleATBTurn();
        }

        private function checkAndSetCharDead(char:Character):void
		{
			trace("checkAndSetCharDead - start");
			var charType:String = playerArr.indexOf(char) >= 0 ? "p" : "e";
			if (char.getHP() <= 0 && !char.getIsDead())
			{
				numDead[charType] += 1;
				char.setIsDead(true);
			}
			trace("checkAndSetCharDead - finish");
		}

		public function checkDead():void
		{
			for (var i:int = 0; i < characterArr.length; i++)
			{
				checkAndSetCharDead(characterArr[i]);
			}
			// for (var i = 0; i < playerArr.length; i++)
			// {
			// checkAndSetCharDead(playerArr[i]);
			// }
			// for (i = 0; i < opponentArr.length; i++)
			// {
			// checkAndSetCharDead(opponentArr[i]);
			// }
			// if (opponentArr[selectedTargetPlayer].getIsDead())
			// {
			// for (var j = 0; j < opponentNum; j++)
			// {
			// if (!opponentArr[j].getIsDead())
			// {
			// selectedTargetPlayer = j;
			// break;
			// }
			// }
			// }
			// if (playerArr[selectedTargetEnemy].getIsDead())
			// {
			// for (j = 0; j < playerNum; j++)
			// {
			// if (!playerArr[j].getIsDead())
			// {
			// selectedTargetEnemy = j;
			// break;
			// }
			// }
			// }
			this.gameUI.updateBar(playerArr, opponentArr);
			checkGameFinish();
		}

        public function checkGameFinish():Boolean
		{
			if (numDead["e"] == 1)
			{
				gameFinish = true;
				return true;
			}
			if (numDead["p"] == 1)
			{
				gameFinish = true;
				return true;
			}
			return false;
			// if (this.gameMode == Constant.GAME_MODE_PVP)
			// {
			// if (numDead["e"] == opponentNum || (controlParty && numDead["e"] == opponentNum) || (!controlParty && opponentArr[0].getIsDead()))
			// {
			// this["opponentMc_" + selectedTargetPlayer]["target"].visible = false;
			// gameFinish = true;
			// winner = "p";
			// }
			// if (numDead["p"] == playerNum || (controlParty && numDead["p"] == playerNum) || (!controlParty && playerArr[0].getIsDead()))
			// {
			// gameFinish = true;
			// winner = "e";
			// }
			// }
			// else
			// {
			// if (numDead["e"] == opponentNum)
			// {
			// this["opponentMc_" + selectedTargetPlayer]["target"].visible = false;
			// gameFinish = true;
			// winner = "p";
			// }
			// if (numDead["p"] == playerNum || (controlParty && numDead["p"] == playerNum) || (!controlParty && playerArr[0].getIsDead()))
			// {
			// gameFinish = true;
			// winner = "e";
			// }
			// }

		}

        private function onGameFinish():void
		{
			this.gameUI.updateBar(playerArr, opponentArr);
			this.gameUI.actionDisplay(false);
			trace("onGameFinish");
			// if (this.gameMode == Constant.GAME_MODE_PVP)
			// {
			// this["statusTxt"].htmlText += "<font color=\"#00FF00\">" + (winner == "p" ? "Player 1" : "Player 2") + " Win</font><br>";
			// }
			// else
			// {
			// this["statusTxt"].htmlText += "<font color=\"#00FF00\">" + (winner == "p" ? "Player" : "Enemy") + " Win</font><br>";

			// }
			// Utils.moveToFront(this["popup"]);
			// this["popup"].visible = true;
			// if (this.gameMode == Constant.GAME_MODE_PVP)
			// {
			// this["popup"].txt.text = (winner == "p" ? "P1" : "P2") + "\nWin";

			// }
			// else
			// {
			// this["popup"].txt.text = (winner == "p" ? "Player" : "Enemy") + " Win";

			// }
			// this["statusTxt"].scrollV = this["statusTxt"].maxScrollV;
		}

        private function updateCharacterATB():void
		{
			var atbConst:int = 1;
			var isFull:Boolean = false;
			while (true)
			{
				for each (var character:Character in characterArr)
				{
					character.updateATB(atbConst); // Assuming there's a method to update character ATB based on their agility
					if (character.isATBFull() && !character.getIsDead())
					{
						isFull = true;
					}
				}
				if (isFull)
				{
					break;
				}
			}
		}

		private function handleATBTurn():void
		{
			// Sort characters by ATB
			characterArr.sort(compareByATB);

			// Select the next character whose ATB is full
			for each (var character:Character in characterArr)
			{
				if (character.isATBFull() && !character.getIsDead())
				{
					character.resetATB();
					nowTurn = character;
					controlCharacter();
					return; // Exit loop after handling one character's turn
				}
			}
		}

		private function compareByATB(characterA:Character, characterB:Character):int
		{
			return characterB.getATB() - characterA.getATB(); // Sort in descending order of ATB
		}

		private function getAliveCharTurn():void
		{
			trace("getAliveCharTurn - start");
			nowTurn = characterArr[turn % characterArr.length];
			if (nowTurn.getIsDead())
			{
				turn++;
				while (true)
				{
					nowTurn = characterArr[turn % characterArr.length];
					if (!nowTurn.getIsDead())
					{
						break;
					}
					turn++;
				}
			}
			trace("getAliveCharTurn - finish");
		}

		private function controlCharacter():void
		{
			trace("controlCharacter - start");
			if (playerArr.indexOf(nowTurn) >= 0)
			{
				this.gameUI.targetVisibility(true, playerArr, opponentArr);
				setSkillAction(nowTurn);
			}
			else
			{
				AISkill();
			}
			trace("controlCharacter - finish");
		}

        public function setSkillAction(char:Character):void
		{
			for (var i:int; i < char.getSkillArr().length; i++)
			{
				var swfName:String = char.getSkillArr()[i];
				var cls:* = Utils.getAsset(Utils.searchIconBySkillName(this.gameUI.allSwfData, swfName), swfName);
				var skillMC:* = cls;
				skillMC.name = swfName.replace("_0", "").replace("_", "");
				Utils.removeChildIfExistAt(this.gameUI["skillMC_" + i]["holder"], 1);
				this.gameUI["skillMC_" + i]["holder"].addChild(skillMC);
				this.gameUI["skillMC_" + i].visible = true;
				this.gameUI["skillMC_" + i]["cdTxt"].text = "";
				this.gameUI["skillMC_" + i]["cdFilter"].visible = false;
				if (Utils.hasMouseEventClick(this.gameUI["skillMC_" + i]["maskMC"]))
				{
					Utils.removeMouseEventClick(this.gameUI["skillMC_" + i]["maskMC"], onSkill);
				}
				Utils.addMouseEventClick(this.gameUI["skillMC_" + i]["maskMC"], onSkill);
				var cpCost:int = BattleUtils.getCPCost(char, char.getSkillList()[i].getChakra());
				if (char.getCP() < cpCost)
				{
					this.gameUI["skillMC_" + i]["cdFilter"].visible = true;
					if (Utils.hasMouseEventClick(this.gameUI["skillMC_" + i]["maskMC"]))
					{
						Utils.removeMouseEventClick(this.gameUI["skillMC_" + i]["maskMC"], onSkill);
					}
				}
				if (char.getCooldownList()[i] > 0)
				{
					this.gameUI["skillMC_" + i]["cdTxt"].text = char.getCooldownList()[i].toString();
					this.gameUI["skillMC_" + i]["cdFilter"].visible = true;
					if (Utils.hasMouseEventClick(this.gameUI["skillMC_" + i]["maskMC"]))
					{
						Utils.removeMouseEventClick(this.gameUI["skillMC_" + i]["maskMC"], onSkill);
					}
				}
				// Hover
				if (Utils.hasMouseEventRollOver(this.gameUI["skillMC_" + i]["maskMC"]))
				{
					Utils.removeMouseEventRollOver(this.gameUI["skillMC_" + i]["maskMC"], onInfoSkill);
				}
				Utils.addMouseEventRollOver(this.gameUI["skillMC_" + i]["maskMC"], onInfoSkill);
				// if (Utils.hasMouseEventRollOut(this.gameUI["skillMC_" + i]["maskMC"]))
				// {
				// Utils.removeMouseEventRollOut(this.gameUI["skillMC_" + i]["maskMC"], onInfoSkill);
				// }
				// Utils.addMouseEventRollOut(this.gameUI["skillMC_" + i]["maskMC"], onInfoSkill);
			}
			this.gameUI["btnPass"].visible = true;
			if (Utils.hasMouseEventClick(this.gameUI["btnPass"]))
			{
				Utils.removeMouseEventClick(this.gameUI["btnPass"], onSkill);
			}
			Utils.addMouseEventClick(this.gameUI["btnPass"], onSkill);
		}

        private function onInfoSkill(e:MouseEvent):void
		{
			var targetName:String = e.target.parent["holder"].getChildAt(1).name;
			var skill:Skill = new Skill(this.gameUI.skillLib[targetName]);
			trace(skill.toString());
		}

        private function onSkill(e:MouseEvent):void
		{
			attacker = nowTurn;
			defender = nowTurn.charType == "p" ? opponentArr[0] : playerArr[0];
			if (e.target.parent.name == "btnPass")
			{
				trace("Pass");
				BattleUtils.charge(attacker);
				BattleUtils.updateSkillCooldown(attacker, -1);
				this.gameUI.actionDisplay(false);
				this.gameUI.updateBar(playerArr, opponentArr);
				setTimeout(function():void
					{
						turn++;
						startBattle();
					}, 300);
				return;
			}
			BattleUtils.setupAvailableSkills(attacker);
			if (attacker.getActionList().length > 0)
			{
				var id:int = e.target.parent.name.split("_")[1];
				var skillid:String = e.target.parent["holder"].getChildAt(1).name;
				var skill:Skill = new Skill(this.gameUI.skillLib[skillid]);
				BattleAction.handleSelectSkill(attacker, skill, defender);
				BattleUtils.updateSkillCooldown(attacker, id);
			}
			this.gameUI.actionDisplay(false);
			this.gameUI.updateBar(playerArr, opponentArr);
			setTimeout(function():void
				{
					turn++;
					startBattle();
				}, 300);
		}

		public function AISkill():void
		{
			attacker = nowTurn;
			defender = nowTurn.charType == "p" ? opponentArr[0] : playerArr[0];
			BattleUtils.setupAvailableSkills(attacker);
			if (attacker.getActionList().length > 0)
			{
				var id:int = Math.floor(Math.random() * attacker.getActionList().length);
				var skillid:String = attacker.getActionList()[id].getId();
				var skill:Skill = new Skill(this.gameUI.skillLib[skillid]);
				BattleAction.handleSelectSkill(attacker, skill, defender);
				BattleUtils.updateSkillCooldown(attacker, attacker.getSkillList().indexOf(attacker.getActionList()[id]));
			}
			else
			{
				trace("Pass");
				BattleUtils.charge(attacker);
				BattleUtils.updateSkillCooldown(attacker, -1);
			}
			this.gameUI.updateBar(playerArr, opponentArr);
			setTimeout(function():void
				{
					turn++;
					startBattle();
				}, 300);
		}
    }
}