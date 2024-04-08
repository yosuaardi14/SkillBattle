package battle
{
    import data.models.*;
    import data.*;
    
    public class BattleEffectUtils
    {
        // EFFECT
        public static function addEffect(skill:Skill, char:Character, target:Character):void
        {
            // check by skill effect_nature to determine buff or debuff
            var isBuff:Boolean = skill.getEffectNature() == SkillData.NATURE_BUFF;
            if (isBuff)
            {

            }
            else
            {

            }
        }

        public static function hasEffect(char:Character, effect:String, isBuff:Boolean):Object
        {
            var charEffectList:Object = isBuff ? char.getBuffList() : char.getDebuffList();
            return charEffectList[effect]; 
        }

        public static function checkEffectChance(skill:Skill):Boolean
        {
            var chanceRandom:int = Math.floor(Math.random() * 100);
            var chance:int = 0;
            if (skill.getEffect()["amount"])
            {
                
            }
            if (chance >= chanceRandom)
            {
                return true;
            }
            return false;
        }
    }
}
