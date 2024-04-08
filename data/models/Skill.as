package data.models
{
    public class Skill
    {
        private var id:String = "";
        private var level:int = 0;
        private var damage:int = 0;
        private var chakra:int = 0;
        private var cooldown:int = 0;
        private var name:String = "";
        private var description:String = "";
        private var tooltip:String = "";
        private var effect:Object;
        private var type:String = "";
        private var target:int = 0;
        private var effectNature:int = 0;
        private var swfName:String = "";

        public function Skill(obj:Object)
        {
            this.id = obj["id"];
            this.level = obj["level"];
            this.damage = obj["damage"];
            this.chakra = obj["cp"];
            this.cooldown = obj["cooldown"];
            this.name = obj["name"];
            this.description = obj["description"];
            this.tooltip = obj["tooltip"];
            this.effect = obj["effect"];
            this.type = obj["type"];
            this.target = obj["target"];
            this.effectNature = obj["effect_nature"];
            this.swfName = obj["swfName"];
        }

        public function getId():String
        {
            return this.id;
        }

        public function getLevel():int
        {
            return this.level;
        }

        public function getDamage():int
        {
            return this.damage;
        }

        public function getChakra():int
        {
            return this.chakra;
        }

        public function getCooldown():int
        {
            return this.cooldown;
        }

        public function getName():String
        {
            return this.name;
        }

        public function getType():String
        {
            return this.type;
        }

        public function getDescription():String
        {
            return this.description;
        }

        public function getTooltip():String
        {
            return this.tooltip;
        }

        public function getTarget():int
        {
            return this.target;
        }

        public function getEffectNature():int
        {
            return this.effectNature;
        }

        public function getSwfName():String
        {
            return this.swfName;
        }

        public function getEffect():Object
        {
            return this.effect;
        }

        public function toString():String
        {
            var str:String = "{id: " + this.id + ", ";
            str += "level: " + this.level + ", ";
            str += "damage: " + this.damage + ", ";
            str += "chakra: " + this.chakra + ", ";
            str += "cooldown: " + this.cooldown + ", ";
            str += "name: " + this.name + ", ";
            str += "description: " + this.description + ", ";
            str += "tooltip: " + this.tooltip + ", ";
            str += "type: " + this.type + ", ";
            str += "effect: {" + "type: " + this.effect["type"] + ", duration: " + this.effect["duration"] + ", amount: " + this.effect["amount"] + "} }";
            return str;
        }
    }
}