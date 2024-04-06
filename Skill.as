package
{
    public class Skill
    {
        private var level:int = 0;
        private var damage:int = 0;
		private var chakra:int = 0;
        private var cooldown:int = 0;
        private var name:String = "";
        private var descr:String = "";
        private var effect:Object;
        private var type:String = "";

        public function Skill(obj: Object){
            this.level = obj["level"];
            this.damage = obj["damage"];
            this.chakra = obj["cp"];
            this.cooldown = obj["cooldown"];
            this.name = obj["name"];
            this.descr = obj["descr"];
            this.effect = obj["effect"];
            this.type = obj["type"];
        }
    }
}