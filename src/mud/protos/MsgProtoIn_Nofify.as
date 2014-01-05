package mud.protos
{
    import mud.protos.base.MudProtoIn;
    
    /**
     * 通知消息
     * @author junho
     * <br/>Create: 2014.01.05
     */    
    public class MsgProtoIn_Nofify extends MudProtoIn
    {
        public static const HEAD:String = "40001";
        
        private var _msg:String = "";
        
        
        public function MsgProtoIn_Nofify()
        {
            super(HEAD);
        }
        
        public function get msg():String
        {
            return _msg;
        }
        
        override protected function analyseRawData(rawData:*):void
        {
            super.analyseRawData(rawData);
            
            _msg = readString();
        }
    }
}