package commons.protos.base
{
    import commons.singleton.MudUtil;

    /**
     * 发送到文字版mud服务器的协议对象
     * @author Junho
     * <br/>Create: 2013.11.28
     */    
    public class MudProtoOut extends ProtoOutBase
    {
        private var _head:String = ""; // 协议头
        protected var _propList:Vector.<Object>;
        
        
        public function MudProtoOut(head:String)
        {
            super();
            _head = head;
            _propList = new Vector.<Object>();
        }
        
        public function get dataStr():String
        {
            return _data.toString();
        }
        
        override public function ready():void
        {
            super.ready();
            
            readyPropList();
            
            var content:String = _head + " ";
            
            var mudProtoOut:MudProtoOut = null;
            var list:Array = null;
            
            const propListLen:uint = _propList.length;
            for (var i:int = 0; i < propListLen; ++i)
            {
                var obj:Object = _propList[i];
                content += parseToStr(obj);
            }
            
            var sss:String = MudUtil.client2MudStr(content);
            _data.writeUTFBytes(MudUtil.client2MudStr(content) + "\n");
        }
        
        
        
        protected function readyPropList():void
        {
            _propList.length = 0;
        }
        
        private function parseToStr(obj:Object):String
        {
            var res:String = "";
            
            var mudProtoOut:MudProtoOut = null;
            var list:Array = null;
            var listLen:uint = 0;
            var i:int = 0;
            
            if (obj is MudProtoOut)
            {
                mudProtoOut = obj as MudProtoOut;
                mudProtoOut.ready();
                res += mudProtoOut.dataStr;
            }
            else if (obj is Array)
            {
                list = obj as Array;
                for (i = 0; i < listLen; ++i)
                {
                    res += parseToStr(list[i]);
                }
            }
            else
            {
                res += String(obj);
            }
            
            return res;
        }
    }
}