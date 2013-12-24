package mud.protos.base
{
    import flash.errors.IllegalOperationError;
    
    import commons.protos.ProtoInBase;
    
    import mud.MudUtil;

    /**
     * 从文字版mud服务器收到的协议
     * @author Junho
     * <br/>Create: 2013.11.27
     */
    public class MudProtoIn extends ProtoInBase
    {
        private var _dataStrList:Array;
        private var _pos:uint = 0;
        
        
        public function MudProtoIn(head:String)
        {
            super(head);
        }
        
        
        
        override protected function analyseRawData(rawData:*):void
        {
            if (!(rawData is Array))
                throw new IllegalOperationError("文字mud输入协议的原始内容必须为字符串数组");
            
            var tmpArray:Array = rawData as Array;
            for each (var obj:Object in tmpArray)
            {
                if (!(obj is String))
                    throw new IllegalOperationError("文字mud输入协议的原始内容必须为字符串数组");
            }
            
            _dataStrList = rawData as Array;
        }
        
        
        
        protected function readInt():int
        {
            var dataStr:String =  _dataStrList[_pos++];
            return int(dataStr);
        }
        
        protected function readString():String
        {
            return _dataStrList[_pos++];
        }
        
        protected function readArray():Array
        {
            var arrayStr:String = _dataStrList[_pos++];
            return MudUtil.toDecode_Array(arrayStr);
        }
    }
}