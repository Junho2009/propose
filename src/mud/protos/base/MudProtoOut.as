package mud.protos.base
{
    import commons.protos.ProtoOutBase;
    
    import mud.MudUtil;

    /**
     * 发送到文字版mud服务器的协议对象
     * @author Junho
     * <br/>Create: 2013.11.28
     */    
    public class MudProtoOut extends ProtoOutBase
    {
        private var _head:String = ""; // 协议头
        private var _sn:uint = 0; // 协议编号
        protected var _propList:Array;
        
        
        public function MudProtoOut(head:String, sn:uint)
        {
            super();
            _head = head;
            _sn = sn;
            _propList = new Array();
        }
        
        override public function get head():*
        {
            return _head;
        }
        
        /**
         * 协议编号
         * @return 
         * 
         */        
        public function get sn():uint
        {
            return _sn;
        }
        
        public function get dataStr():String
        {
            return _data.toString();
        }
        
        override public function ready():void
        {
            super.ready();
            
            _propList.length = 0;
            _propList.push(_sn);
            readyPropList();
            
            var content:String = _head + " ";
            content += MudUtil.toEncode_ProtoParamsStr(_propList);
            _data.writeUTFBytes(content + "\n");
        }
        
        
        
        /**
         * 准备属性列表
         * <br/>子类根据协议的约定，指定好属性在列表中的顺序
         */
        protected function readyPropList():void
        {
        }
    }
}