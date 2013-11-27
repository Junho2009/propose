package commons.singleton.protos
{
    import flash.utils.ByteArray;

    /**
     * 从文字版mud服务器收到的协议
     * @author Junho
     * <br/>Create: 2013.11.27
     */    
    public class MudProtoIn extends ProtoInBase
    {
        private static const _DataDelimiter:String = "|";
        private var _dataStrList:Vector.<String>;
        private var _pos:uint = 0;
        
        
        public function MudProtoIn()
        {
            super();
        }
        
        public function readInt():int
        {
            var dataStr:String =  _dataStrList[_pos++];
            return int(dataStr);
        }
        
        public function readString():String
        {
            return _dataStrList[_pos++];
        }
        
        override protected function analyseRawData(rawData:ByteArray):void
        {
            _dataStrList = rawData.toString().split(_DataDelimiter);
        }
    }
}