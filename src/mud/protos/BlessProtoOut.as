package mud.protos
{
    import mud.protos.base.MudProtoOut;
    
    /**
     * 送祝福协议
     * @author junho
     * <br/>Create: 2013.12.08
     */
    public class BlessProtoOut extends MudProtoOut
    {
        public var name:String;
        public var msg:String;
        
        
        public function BlessProtoOut()
        {
            super("bless");
        }
        
        override protected function readyPropList():void
        {
            _propList.push(name);
            _propList.push(msg);
        }
    }
}