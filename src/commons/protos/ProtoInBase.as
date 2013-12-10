package commons.protos
{
    import flash.errors.IllegalOperationError;

    /**
     * 输入协议对象基类
     * @author Junho
     * <br/>Create: 2013.11.27
     */
    public class ProtoInBase implements IProto
    {
        protected var _head:*;
        protected var _rawData:*;
        
        
        public function ProtoInBase(head:*)
        {
            _head = head;
        }
        
        public function init(rawData:*):void
        {
            if (null == rawData)
                throw new IllegalOperationError("传入的数据对象为空");
            
            _rawData = rawData;
            analyseRawData(rawData);
        }
        
        public function get head():*
        {
            return _head;
        }
        
        protected function analyseRawData(rawData:*):void
        {
            //...
        }
    }
}