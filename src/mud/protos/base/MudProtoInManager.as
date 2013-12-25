package mud.protos.base
{
    import flash.utils.ByteArray;
    
    import commons.debug.Debug;
    import commons.manager.IProtoInManager;
    import commons.protos.ProtoInBase;
    import commons.protos.ProtoInList;
    
    import mud.MudUtil;
    import mud.protos.BlessProtoIn;
    import mud.protos.BlessProtoIn_BlessList;
    import mud.protos.TestProtoIn;
    
    /**
     * mud版输入协议的管理器
     * @author Junho
     * <br/>Create: 2013.11.30
     */
    public class MudProtoInManager implements IProtoInManager
    {
        private var _bFirstRecv:Boolean = true;
        
        
        
        public function MudProtoInManager()
        {
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
            var protoStrList:Array = MudUtil.toDecode_ProtoInStrList(rawStr);
            const protoStrListLen:uint = protoStrList.length;
            for (var i:int = 0; i < protoStrListLen; ++i)
            {
                var protoInStr:String = protoStrList[i];
                if (!MudUtil.isValidProtoInStr(protoInStr))
                    continue;
                
                var paramStrList:Array = MudUtil.toDecode_ProtoParamStrList(protoInStr);
                
                var head:String = paramStrList.shift();
                var protoIn:ProtoInBase = ProtoInList.getInstance().createProtoIn(head);
                if (null == protoIn)
                {
                    Debug.log("未绑定{0}输入协议", head);
                    continue;
                }
                
                protoIn.init(paramStrList);
                protoInList.push(protoIn);
            }
            
            return protoInList;
        }
    }
}