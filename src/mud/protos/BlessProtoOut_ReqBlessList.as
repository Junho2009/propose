package mud.protos
{
    import mud.protos.base.MudProtoOut;
    
    public class BlessProtoOut_ReqBlessList extends MudProtoOut
    {
        public var page:uint = 0;
        
        public function BlessProtoOut_ReqBlessList()
        {
            super("bless", 131403);
        }
        
        override protected function readyPropList():void
        {
            _propList.push(page);
        }
    }
}