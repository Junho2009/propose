package mud.protos
{
    import mud.protos.base.MudProtoOut;
    
    /**
     * 祝福输出协议-送祝福
     * @author junho
     * <br/>Create: 2013.12.08
     */
    public class BlessProtoOut_SendBless extends MudProtoOut
    {
        public var name:String;
        public var msg:String;
        
        
        public function BlessProtoOut_SendBless()
        {
            super("bless", 131402);
        }
        
        override protected function readyPropList():void
        {
            _propList.push(name);
            _propList.push(msg);
        }
    }
}