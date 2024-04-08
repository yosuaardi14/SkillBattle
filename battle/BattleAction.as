package battle
{
    import data.*;
    import data.models.*
    
    public class BattleAction
    {
        public function BattleAction()
        {
            super();
        }

        public static function handleSelectSkill(char:Character, skill:Skill, target:Character):void
        {
            var skillTarget:int = skill.getTarget();
            var cpCost:int = skill.getChakra();
            BattleUtils.handleCPCost(char, cpCost);
            if (skillTarget == SkillData.TARGET_HOSTILE || skillTarget == SkillData.TARGET_FRIENDLY)
            {
                trace("handleAreaTargetSkill(char, skill, target) not implemented yet");
                // handleAreaTargetSkill(char, skill, target);
            }
            else
            {
                handleSingleTargetSkill(char, skill, target);
            }
        }

        public static function handleSingleTargetSkill(char:Character, skill:Skill, target:Character):void
        {
            var skillTarget:int = skill.getTarget();
            if (skillTarget == SkillData.TARGET_SELF)
            {
                handleSelfTargetSkill(char, skill, target);
            }
            else if (skillTarget == SkillData.TARGET_SINGLE_FRIENDLY)
            {
                trace("handleSingleFriendlyTargetSkill(char, skill, target) not implemented yet");
                // handleSingleFriendlyTargetSkill(char, skill, target);
            }
            else
            {
                handleSingleHostileSkill(char, skill, target);
            }
        }

        public static function handleSingleHostileSkill(char:Character, skill:Skill, target:Character):void
        {
            if (BattleUtils.checkHit(char, target))
            {
                var damage:int = skill.getDamage();
                var effect:Object = skill.getEffect();
                if (damage != 0)
                {
                    damage = BattleUtils.calcDamage(BattleUtils.getFinalDamage(damage, char, target));
                }
                if (effect["type"] != "")
                {
                    BattleUtils.addEffect(skill, char, target);
                }
                if (BattleUtils.checkDamageRebound(damage, char, target))
                {
                    BattleUtils.updateHP(char, -damage);
                }
                else
                {
                    BattleUtils.updateHP(target, -damage);
                }
                trace("Target Hit damage:" + damage + " effect:" + effect["type"]);
            }
            else
            {
                // Target Dodge
                trace("Target Dodge");
            }
        }

        public static function handleSelfTargetSkill(char:Character, skill:Skill, target:Character):void
        {
            target = char;
            var effect:Object = skill.getEffect();
            if (effect["type"] != "")
            {
                BattleUtils.addEffect(skill, char, target);
                trace("Target Self" + " effect:" + effect["type"]);
            }
        }

        // public static function handleSingleFriendlyTargetSkill(char:Character, skill:Skill, target:Character):void
        // {

        // }

        // public static function handleAreaTargetSkill(char:Character, skill:Skill, target:Character):void
        // {
        // var skillTarget:int = skill.getTarget();
        // if (skillTarget == SkillData.TARGET_HOSTILE)
        // {
        // handleAreaHostileSkill(char, skill, target);
        // }
        // else if (skillTarget == SkillData.TARGET_FRIENDLY)
        // {
        // handleAreaFriendlySkill(char, skill, target);
        // }
        // }

        // public static function handleAreaHostileSkill(char:Character, skill:Skill, target:Character):void
        // {

        // }

        // public static function handleAreaFriendlySkill(char:Character, skill:Skill, target:Character):void
        // {

        // }

    }
}