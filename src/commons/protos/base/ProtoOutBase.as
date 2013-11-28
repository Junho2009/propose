package commons.protos.base
{
    import flash.utils.ByteArray;

    /**
     * 发出去的协议对象基类
     * @author Junho
     * <br/>Create: 2013.11.28
     */
    public class ProtoOutBase
    {
        protected var _data:ByteArray = new ByteArray();
        
        
        public function ProtoOutBase()
        {
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