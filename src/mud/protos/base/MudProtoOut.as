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
        protected var _propList:Vector.<Object>;
        
        
        public function MudProtoOut(head:String, sn:uint)
        {
            super();
            _head = head;
            _sn = sn;
            _propList = new Vector.<Object>();
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
            
            readyPropList();
            
            var content:String = _head + " " + _sn.toString();
            
            var mudProtoOut:MudProtoOut = null;
            var list:Array = null;
            
            const propListLen:uint = _propList.length;
            
            content += MudUtil.DataDelimiter;
            if (propListLen > 0)
            {
                for (var i:int = 0; i < propListLen; ++i)
                {
                    var obj:Object = _propList[i];
                    content += MudUtil.encodeParamDelimiter(parseToStr(obj));
                    
                    if (i < propListLen-1)
                        content += MudUtil.DataDelimiter;
                }
            }
            
            _data.writeUTFBytes(MudUtil.encodeLineBreaks(content) + "\n");
        }
        
        
        
        /**
         * 准备属性列表
         * <br/>子类根据协议的约定，指定好属性在列表中的顺序
         */
        protected function readyPropList():void
        {
            _propList.length = 0;
        }
        
        
        
        /**
         * 将对象转换为字符串
         * @param obj:Object
         * @return String
         * 
         */
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