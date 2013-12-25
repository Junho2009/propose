package mud.protos
{
    import mud.protos.base.MudProtoIn;
    
    /**
     * 请求祝福数据信息的返回协议
     * @author junho
     * <br/>Create: 2013.12.26
     */    
    public class BlessProtoIn_BlessInfo extends MudProtoIn
    {
        public static const HEAD:String = "131401";
        
        
        private var _count:uint;
        private var _page:uint;
        
        
        public function BlessProtoIn_BlessInfo()
        {
            super(HEAD);
        }
        
        public function get count():uint
        {
            return _count;
        }
        
        public function get page():uint
        {
            return _page;
        }
        
        override protected function analyseRawData(rawData:*):void
        {
            super.analyseRawData(rawData);
            
            _count = readInt();
            _page = readInt();
        }
    }
}