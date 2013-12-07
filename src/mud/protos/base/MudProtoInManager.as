package mud.protos.base
{
    import flash.errors.IllegalOperationError;
    import flash.utils.ByteArray;
    
    import commons.debug.Debug;
    import commons.manager.IProtoInManager;
    import commons.protos.ProtoInBase;
    import commons.protos.ProtoInList;
    
    import mud.MudUtil;
    import mud.protos.TestProtoIn;
    
    /**
     * mud版输入协议的管理器
     * @author Junho
     * <br/>Create: 2013.11.30
     */
    public class MudProtoInManager implements IProtoInManager
    {
        private static var _allowInstance:Boolean = false;
        private static var _instance:MudProtoInManager = null;
        
        private var _bFirstRecv:Boolean = true;
        
        
        
        public function MudProtoInManager()
        {
            if(!_allowInstance)
                throw new IllegalOperationError("MudProtoInManager is a singleton class.");
            
            // 绑定输入协议
            ProtoInList.getInstance().bind("12345", TestProtoIn);
        }
        
        /**
         * 获取当前实例 
         * @return MudProtoInManager
         * 
         */	
        public static function getInstance():MudProtoInManager
        {
            if(null == _instance)
            {
                _allowInstance = true;
                _instance = new MudProtoInManager();
                _allowInstance = false;
            }
            
            return _instance;
        }
        
        
        public function toProtoIn(rawData:ByteArray):Vector.<ProtoInBase>
        {
            if (_bFirstRecv)
            {
                rawData.position = 6; // 跳过类似握手协议的内容
                _bFirstRecv = false;
            }
            
            var protoInList:Vector.<ProtoInBase> = new Vector.<ProtoInBase>();
            
            var rawStr:String = rawData.readUTFBytes(rawData.bytesAvailable);
            var protoStrList:Array = rawStr.split(MudUtil.ProtoDelimiter);
            const protoStrListLen:uint = protoStrList.length;
            for (var i:int = 0; i < protoStrListLen; ++i)
            {
                var protoInStr:String = protoStrList[i];
                if (!isValidProtoInStr(protoInStr))
                    continue;
                
                var dataStrList:Array = protoInStr.split(MudUtil.DataDelimiter);
                var head:String = dataStrList.shift();
                var protoIn:ProtoInBase = ProtoInList.getInstance().createProtoIn(head);
                if (null == protoIn)
                {
                    Debug.log("未绑定{0}输入协议", head);
                    continue;
                }
                
                protoIn.init(dataStrList);
                
                protoInList.push(protoIn);
            }
            
            return protoInList;
        }
        
        
        
        private function isValidProtoInStr(str:String):Boolean
        {
            return (0 == str.search(/\d+\|/));
        }
    }
}