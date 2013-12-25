package mud.protos
{
    import commons.vo.BlessVO;
    
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
            super(HEAD);
            _blessList = new Vector.<BlessVO>();
        }
        
        public function get blessList():Vector.<BlessVO>
        {
            return _blessList;
        }
        
        
        override protected function analyseRawData(rawData:*):void
        {
            super.analyseRawData(rawData);
            
            _blessList.length = 0;
            
            var blessObjList:Array = readArray();
            const blessObjListLen:uint = blessObjList.length;
            for (var i:int = 0; i < blessObjListLen; ++i)
            {
                var blessObj:Object = blessObjList[i];
                var bless:BlessVO = new BlessVO(blessObj);
                _blessList.push(bless);
            }
        }
    }
}