package commons.protos
{
    import flash.utils.ByteArray;

    /**
     * 输出协议对象基类
     * @author Junho
     * <br/>Create: 2013.11.28
     */
    public class ProtoOutBase implements IProto
    {
        protected var _data:ByteArray = new ByteArray();
        
        
        public function ProtoOutBase()
        {
        }
        
        public function get head():*
        {
            return null;
        }
        
        public function get data():ByteArray
        {
            return _data;
        }
        
        public function ready():void
        {
            _data.clear();
        }
    }
}