package mud.protos
{
    import mud.protos.base.MudProtoIn;
    
    /**
     * 鲜花输入协议-已发送鲜花的信息
     * @author junho
     * <br/>Create: 2014.01.05
     */    
    public class FlowerProtoIn_SentInfo extends MudProtoIn
    {
        public static const HEAD:String = "111101";
        
        
        private var _selfSentNum:int = 0;
        private var _sentTotal:uint = 0;
        
        
        public function FlowerProtoIn_SentInfo()
        {
            super(HEAD);
        }
        
        /**
         * 自己已送花的数量
         * <br/>注：如果值为小于0，表示可以无视这个字段
         * @return uint
         * 
         */        
        public function get selfSentNum():int
        {
            return _selfSentNum;
        }
        
        /**
         * 全服已送花数量
         * @return uint
         * 
         */        
        public function get sentTotal():uint
        {
            return _sentTotal;
        }
        
        
        
        override protected function analyseRawData(rawData:*):void
        {
            super.analyseRawData(rawData);
            
            _selfSentNum = readInt();
            _sentTotal = readInt();
        }
    }
}