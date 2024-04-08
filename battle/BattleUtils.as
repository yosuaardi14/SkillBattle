package battle
{
    import data.models.*;
    
    public class BattleUtils
    {
        // 
        public static function updateHP(char:Character, health:int):void
        {
            char.setHP((char.getHP() + health));
        }

        public static function updateCP(char:Character, chakra:int):void
        {
            char.setCP((char.getCP() + chakra));
        }

        public static function handleCPCost(char:Character, chakra:int):void
        {
            var cpCost:int = getCPCost(char, chakra);
            updateCP(char, -cpCost);
        }

        public static function charge(target:Character):void
        {
            var baseAmount:int = 25;
            var chargeAmount:int = Math.round(target.getMaxCP() * (baseAmount / 100));
            updateCP(target, chargeAmount);
        }

        public static function getCPCost(char:Character, chakra:int):int
        {
            // FUTURE
            // var tempChakra = chakra;
            // var petSaveCP = hasEffect("pet_save_cp", obj, true);
            // if (petSaveCP["has"])
            // {
            // tempChakra = chakra * (petSaveCP["amount"] / 100);
            // chakra = chakra - tempChakra;
            // }
            return chakra;
        }

        public static function setInitialCooldown(char:Character):void
		{
			var cooldown:Array = [];
			for (var i:* in char.getSkillList())
			{
				cooldown[i] = 0;
			}
            char.setCooldownList(cooldown);
		}

        public static function updateSkillCooldown(char:Character, skillNo:int):void
        {
            var cooldown:Array = char.getCooldownList();
            for (var i:* in cooldown)
            {
                if (cooldown[i] > 0)
                {
                    cooldown[i]--;
                }
            }
            if (skillNo != -1)
            {
                cooldown[skillNo] = char.getSkillList()[skillNo].getCooldown();
            }
            char.setCooldownList(cooldown);
        }

        public static function setupAvailableSkills(char:Character):void
        {
            char.setActionList([]);
            for (var i:* in char.getSkillList())
            {
                // TODO
                var cpCost:int = BattleUtils.getCPCost(char, char.getSkillList()[i].getChakra());
                if (char.getCP() < cpCost)
                {
                    trace(char.getSkillList()[i].getName() + " CP: "+ cpCost);
                    continue;
                }
                if (char.getCooldownList()[i] <= 0)
                {
                    char.getActionList().push(char.getSkillList()[i]);
                }
            }
        }

        // 
        public static function checkHit(char:Character, target:Character):Boolean
        {
            return true;
        }

        // DAMAGE
        public static function calcDamage(damage:int):int
        {
            var constVal:* = 0.2;
            var minVal:* = damage - damage * constVal;
            var maxVal:* = damage + damage * constVal;
            return Math.round(Math.random() * (maxVal - minVal) + minVal);
        }

        public static function getFinalDamage(damage:int, char:Character, target:Character):int
        {
            return damage;
        }

        public static function checkDamageRebound(damage:int, char:Character, target:Character):Boolean
        {
            return false;
        }

        // EFFECT
        public static function addEffect(skill:Skill, char:Character, target:Character):void
        {
            BattleEffectUtils.addEffect(skill, char, target);
        }
    }
}
