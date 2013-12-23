package mud.protos
{
    import commons.vo.BlessVO;
    
    import mud.MudUtil;
    import mud.protos.base.MudProtoIn;
    
    /**
     * 请求祝福列表的结果返回协议
     * @author junho
     * <br/>Create: 2013.12.23
     */    
    public class BlessProtoIn_BlessList extends MudProtoIn
    {
        public static const HEAD:String = "131403";
        
        private var _blessList:Vector.<BlessVO>;
        
        
        public function BlessProtoIn_BlessList()
        {
            super(head);
            _blessList = new Vector.<BlessVO>();
        }
        
        public function get blessList():Vector.<BlessVO>
        {
            return _blessList;
        }
        
        
        override protected function analyseRawData(rawData:*):void
        {
            super.analyseRawData(rawData);
            
            var rawStr:String = readString();
            
            _blessList.length = 0;
            
            var blessStrList:Array = rawStr.split(MudUtil.ArrayElementDelimiter);
            const blessStrListLen:uint = blessStrList.length;
            for (var i:int = 0; i < blessStrListLen; ++i)
            {
                var blessStr:String = blessStrList[i];
                var blessInfo:Array = blessStr.split(MudUtil.ElementPropDelimiter);
                
                var authorName:String = blessInfo[0];
                var msg:String = blessInfo[1];
                var time:uint = blessInfo[2];
                
                var bless:BlessVO = new BlessVO(authorName, msg, time);
                _blessList.push(bless);
            }
        }
    }
}