package mud.protos
{
    import mud.protos.base.MudProtoOut;
    
    /**
     * 祝福输出协议-祝福列表数据
     * @author junho
     * <br/>Create: 2013.12.23
     */    
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