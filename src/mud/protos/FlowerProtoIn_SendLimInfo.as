package mud.protos
{
    import mud.protos.base.MudProtoIn;
    
    /**
     * 鲜花输入协议-送花限额信息
     * @author junho
     * <br/>Create: 2014.01.02
     */    
    public class FlowerProtoIn_SendLimInfo extends MudProtoIn
    {
        public static const HEAD:String = "111102";
        
        
        private var _duration:uint = 0;
        private var _limitCount:uint = 0;
        
        
        public function FlowerProtoIn_SendLimInfo()
        {
            super(HEAD);
        }
        
        /**
         * 持续时间（秒）
         * @return uint
         * 
         */        
        public function get duration():uint
        {
            return _duration;
        }
        
        /**
         * 合计飘花限额
         * @return uint
         * 
         */        
        public function get limitCount():uint
        {
            return _limitCount;
        }
        
        
        
        override protected function analyseRawData(rawData:*):void
        {
            super.analyseRawData(rawData);
            
            _duration = readInt();
            _limitCount = readInt();
        }
    }
}