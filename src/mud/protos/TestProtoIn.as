package mud.protos
{
    import mud.protos.base.MudProtoIn;
    
    public class TestProtoIn extends MudProtoIn
    {
        public static const HEAD:String = "12345";
        
        private var _name:String;
        private var _value:uint;
        private var _msg:String;
        
        
        public function TestProtoIn()
        {
            super(HEAD);
        }
        
        public function get name():String
        {
            return _name;
        }
        
        public function get value():uint
        {
            return _value;
        }
        
        public function get msg():String
        {
            return _msg;
        }
        
        override protected function analyseRawData(rawData:*):void
        {
            super.analyseRawData(rawData);
            
            _name = readString();
            _value = readInt();
            _msg = readString();
        }
    }
}