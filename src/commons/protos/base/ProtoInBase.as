package commons.protos.base
{
    import flash.errors.IllegalOperationError;
    import flash.utils.ByteArray;

    /**
     * 收到的协议对象基类
     * @author Junho
     * <br/>Create: 2013.11.27
     */
    public class ProtoInBase
    {
        protected var _rawData:ByteArray;
        
        
        public function ProtoInBase()
        {
        }
        
        public function init(rawData:ByteArray):void
        {
            if (null == rawData)
                throw new IllegalOperationError("传入的二进制数据为空");
            
            _rawData = rawData;
            analyseRawData(rawData);
        }
        
        protected function analyseRawData(rawData:ByteArray):void
        {
            //...
        }
    }
}