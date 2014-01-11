package mud.protos
{
    import mud.protos.base.MudProtoIn;
    
    /**
     * 鲜花输入协议-公告某个用户的赠花数
     * @author junho
     * <br/>Create: 2014.01.11
     */    
    public class FlowerProtoIn_UserSentInfoNotice extends MudProtoIn
    {
        public static const HEAD:String = "111104";
        
        
        private var _name:String = "";
        private var _sentNum:uint = 0;
        
        
        public function FlowerProtoIn_UserSentInfoNotice()
        {
            super(HEAD);
        }
        
        /**
         * 送花人名称
         * @return String
         * 
         */        
        public function get name():String
        {
            return _name;
        }
        
        /**
         * 已赠花数
         * @return uint
         * 
         */        
        public function get sentNum():uint
        {
            return _sentNum;
        }
        
        
        
        override protected function analyseRawData(rawData:*):void
        {
            super.analyseRawData(rawData);
            
            _name = readString();
            _sentNum = readInt();
        }
    }
}