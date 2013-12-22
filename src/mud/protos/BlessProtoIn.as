package mud.protos
{
    import mud.protos.base.MudProtoIn;
    
    public class BlessProtoIn extends MudProtoIn
    {
        public static const HEAD:String = "1314";
        
        private var _authorName:String;
        private var _msg:String;
        private var _sendTime:uint;
        
        
        public function BlessProtoIn()
        {
            super(HEAD);
        }
        
        public function get authorName():String
        {
            return _authorName;
        }
        
        public function get msg():String
        {
            return _msg;
        }
        
        public function get sendTime():uint
        {
            return _sendTime;
        }
        
        override protected function analyseRawData(rawData:*):void
        {
            super.analyseRawData(rawData);
            
            _authorName = readString();
            _msg = readString();
            _sendTime = readInt();
        }
    }
}