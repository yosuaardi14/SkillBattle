package selection
{
    import flash.events.MouseEvent;

    import data.models.*;
    import utils.*;
    import data.*;

    public class SelectionManager
    {
        public var skillPlayerArr:Vector.<Skill> = new Vector.<Skill>();
        public var skillOpponentArr:Vector.<Skill> = new Vector.<Skill>();
        public var charNum:int;
        public var skillSelectTurn:String = "p";
        // FRAME 2 - CHARACTER PAGE
        public var currentPage:int = 1;
        public var maxPage:int = 1;

        public var gameUI:Main;
        public var characterArr:Vector.<Character>;

        public function SelectionManager(characterArr:Vector.<Character>, gameUI:Main)
        {
            this.gameUI = gameUI;
            this.characterArr = characterArr;
            
			this.skillSelectTurn = "p";
            var player:Character = new Character();
            player.setName("Player");
            player.charType = "p";
            var opponent:Character = new Character();
            opponent.setName("Opponent");
            opponent.charType = "e";
            this.characterArr.push(player);
            this.characterArr.push(opponent);

            this.currentPage = 1;
            this.maxPage = Math.ceil(this.gameUI.skillList.length / Constant.MAX_SKILL_IN_GAME);
            Utils.addMouseEventClick(this.gameUI["btnPrev"], this.changeSkillPage);
            Utils.addMouseEventClick(this.gameUI["btnNext"], this.changeSkillPage);

        }

        public function initSelection():void
        {
            buttonVisibility();
            showSkillList();
        }

        private function changeSkillPage(e:MouseEvent):void
        {
            if (e.target == this.gameUI["btnNext"])
            {
                if (this.currentPage < this.maxPage)
                {
                    this.currentPage += 1;
                    this.hideSkillList();
                    this.showSkillList();
                }
            }
            else if (e.target == this.gameUI["btnPrev"])
            {
                if (this.currentPage > 1)
                {
                    this.currentPage -= 1;
                    this.hideSkillList();
                    this.showSkillList();
                }
            }
            buttonVisibility();
        }

        private function buttonVisibility():void
        {
            this.gameUI["btnPrev"].visible = this.currentPage > 1;
            this.gameUI["btnNext"].visible = this.currentPage < this.maxPage;
        }

        private function hideSkillList():void
        {
            for (var i:int = 0; i < Constant.MAX_SKILL_IN_GAME; i++)
            {
                Utils.removeChildIfExistAt(this.gameUI["skill_" + i]["holder"], 1);
                this.gameUI["skill_" + i].visible = false;
                this.gameUI["skill_" + i]["cdTxt"].text = "";
                this.gameUI["skill_" + i]["cdFilter"].visible = false;
                if (Utils.hasMouseEventClick(this.gameUI["skill_" + i]["maskMC"]))
                {
                    Utils.removeMouseEventClick(this.gameUI["skill_" + i]["maskMC"], onSelectSkill);
                }
            }
        }

        private function showSkillList():void
        {
            var start:int = (currentPage - 1) * Constant.MAX_SKILL_IN_GAME;
            var end:int = Math.min(this.gameUI.skillList.length, this.currentPage * Constant.MAX_SKILL_IN_GAME);
            var index:int = 0;
            for (var i:int = start; i < end; i++)
            {
                try
                {
                    var skillSwfName:String = this.gameUI.skillList[i]; // getRandomSkill(); // skillList[i];
                    var cls:* = Utils.getAsset(Utils.searchIconBySkillName(this.gameUI.allSwfData, skillSwfName), skillSwfName);
                    var skillMC:* = cls;
                    skillMC.name = skillSwfName.replace("_0", "").replace("_", "");
                    Utils.removeChildIfExistAt(this.gameUI["skill_" + index]["holder"], 1);
                    this.gameUI["skill_" + index]["holder"].addChild(skillMC);
                    this.gameUI["skill_" + index].visible = true;
                    this.gameUI["skill_" + index]["cdTxt"].text = "";
                    this.gameUI["skill_" + index]["cdFilter"].visible = false;
                    if (Utils.hasMouseEventClick(this.gameUI["skill_" + index]["maskMC"]))
                    {
                        Utils.removeMouseEventClick(this.gameUI["skill_" + index]["maskMC"], onSelectSkill);
                    }
                    Utils.addMouseEventClick(this.gameUI["skill_" + index]["maskMC"], onSelectSkill);
                    index++;
                }
                catch (e)
                {
                    trace(e);
                }
            }
        }

        private function getRandomSkill():String
        {
            var rand:int = Math.floor(Math.random() * this.gameUI.skillList.length);
            return this.gameUI.skillList[rand];
        }

        private function onSelectSkill(e:MouseEvent):void
        {
            if (characterArr[0].getSkillArr().length == Constant.MAX_SKILL_PER_CHAR && characterArr[1].getSkillArr().length == Constant.MAX_SKILL_PER_CHAR)
            {
                trace("skillSelectDone");
                this.gameUI.characterArr = this.characterArr;
                this.gameUI.gotoAndStop(3);
                return;
            }
            var targetName:String = e.target.parent["holder"].getChildAt(1).name;
            var skill:Skill = new Skill(this.gameUI.skillLib[targetName]);
            trace(skill.toString());
            var i:Array = characterArr[0].getSkillArr();
            var turn:String = "C";
            if (skillSelectTurn == "e")
            {
                i = characterArr[1].getSkillArr();
                turn = "E";
            }
            if (i.indexOf(skill.getSwfName()) >= 0)
            {
                trace("Duplicate Skill");
                return;
            }
            if (i.length < Constant.MAX_SKILL_PER_CHAR)
            {
                var skillMC:* = Utils.getAsset(Utils.searchIconBySkillName(this.gameUI.allSwfData, skill.getSwfName()), skill.getSwfName());
                // 
                Utils.removeChildIfExistAt(this.gameUI["skill" + turn + "_" + i.length]["holder"], 1);
                this.gameUI["skill" + turn + "_" + i.length]["holder"].addChild(skillMC);
                this.gameUI["skill" + turn + "_" + i.length].visible = true;
                this.gameUI["skill" + turn + "_" + i.length]["cdTxt"].text = "";
                this.gameUI["skill" + turn + "_" + i.length]["cdFilter"].visible = false;
                if (skillSelectTurn == "e")
                {
                    // skillOpponentArr.push(skill);
                    characterArr[1].getSkillList().push(skill);
                    characterArr[1].getSkillArr().push(skill.getSwfName());
                }
                else
                {
                    // skillPlayerArr.push(skill);
                    characterArr[0].getSkillList().push(skill);
                    characterArr[0].getSkillArr().push(skill.getSwfName());
                }
            }
            if (characterArr[0].getSkillArr().length >= Constant.MAX_SKILL_PER_CHAR)
            {
                skillSelectTurn = "e";
            }
            if (characterArr[0].getSkillArr().length == Constant.MAX_SKILL_PER_CHAR && characterArr[1].getSkillArr().length == Constant.MAX_SKILL_PER_CHAR)
            {
                trace("skillSelectDone");
                this.gameUI.characterArr = this.characterArr;
                this.gameUI.gotoAndStop(3);
                return;
            }
        }
    }
}